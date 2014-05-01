package cookix.tools.console;

import haxe.ds.StringMap;

typedef Option = {
    var name : String;
    var description : String;
    @:optional var callback : ?String->Void; // Function which takes the value as a parameter
    @:optional var valueMandatory : Bool;
    @:optional var valueDescription : String;
}

typedef Command = {
    var name        : String;
    var description : String;
    var callback    : ?StringMap<String>->Void; // Function which takes the value as a parameter
    var options     : StringMap<Option>; // Contains at least --help
}

/**
* @author Axel Anceau (Peekmo)
* Manage commands for Cookix
*/
class CommandReader
{
    /**
    * @var commands : StringMap<Command> All available commands
    */
    public static var commands : StringMap<Command>;

    /**
    * Adds a new command to list
    * @param command  : {name: String, description: String, callback: ?StringMap<String>->Void} Command to add
    * @param ?options : Array<Option> Options associated to the given 
    */
    public static function push(commandData : {name: String, description: String, callback: ?StringMap<String>->Void}, ?options : Array<Option>) : Void
    {
        var command : Command = {
            name: commandData.name,
            description: commandData.description,
            callback: commandData.callback,
            options: new StringMap<Option>()
        };
        
        if (options != null) {
            for (option in options.iterator()) {
                if (option.name == "help") {
                    throw "You can't create a --help option. This option is created by Cookix by default";
                }

                if (option.valueMandatory == null) {
                    option.valueMandatory = false;
                }

                command.options.set(option.name, option);                
            }
        }

        command.options.set("help", {
            name: "help",
            description: "Print options allowed for this command",
            callback: function(?value: String) {
                Console.showHelp(command.name);
            },
            valueMandatory: false  
        });

        commands.set(command.name, command);
    }

    /**
    * Checks all commands received
    */
    public static function check() : Void
    {
        // Check command
        if (!commands.exists(Console.command)) {
            throw new CliException("Command not found : " + Console.command);
        }

        var command = commands.get(Console.command);

        for (option in Console.options.keys()) {
            if (!command.options.exists(option)) {
                throw new CliException("Option not found : " + option, Console.command);
            }

            var optionType = command.options.get(option);

            if (optionType.valueMandatory && Console.options.get(option) == null) {
                throw new CliException("A value is mandatory for this option : " + option, Console.command);
            }
        }
    }

    /**
     * Call different callbacks (Command's one first, and options's one after)
     */
    public static function call() : Void
    {
        check();

        var command = commands.get(Console.command);
        command.callback(Console.options);

        for (optionName in Console.options.keys()) {
            var option = command.options.get(optionName);

            if (option.callback != null) {
                option.callback(Console.options.get(option.name));
            }
        }
    }

    /**
    * Init function, instanciate commands array
    */
    public static function __init__() : Void
    {
        commands = new StringMap<Command>();
    }
}