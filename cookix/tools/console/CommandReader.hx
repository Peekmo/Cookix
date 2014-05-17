package cookix.tools.console;

import haxe.ds.StringMap;

typedef Option = {
    var name : String;
    var description : String;
    @:optional var callback : String; // Function which takes the value as a parameter
    @:optional var valueMandatory : Bool;
    @:optional var valueDescription : String;
}

typedef Command = {
    var name        : String;
    var description : String;
    var classPath   : String;
    var options     : StringMap<Option>; // Contains at least --help
    var callback    : String; // Name of the function which takes the value as a parameter
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
    public static function push(commandData : {name: String, description: String, classPath: String, ?callback: String}, ?options : Array<Option>) : Void
    {
        var command : Command = {
            name: commandData.name,
            description: commandData.description,
            classPath : commandData.classPath,
            callback: commandData.callback != null ? commandData.callback : 'execute',
            options: new StringMap<Option>()
        };

        command.options.set("help", {
            name: "help",
            description: "Print options allowed for this command",
            callback: 'help',
            valueMandatory: false  
        });
        
        if (options != null) {
            for (option in options.iterator()) {
                if (option.valueMandatory == null) {
                    option.valueMandatory = false;
                }

                command.options.set(option.name, option);                
            }
        }

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

        // Create command's class
        var oClass : Dynamic = Type.createEmptyInstance(Type.resolveClass(command.classPath));

        // Call _initialization_
        Reflect.callMethod(oClass, Reflect.field(oClass, '_initialization_'), []);

        // Class's callback
        Reflect.callMethod(oClass, Reflect.field(oClass, command.callback), []);

        for (optionName in Console.options.keys()) {
            var option = command.options.get(optionName);

            if (option.callback != null) {
                Reflect.callMethod(oClass, Reflect.field(oClass, option.callback), [Console.options.get(option.name)]);
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