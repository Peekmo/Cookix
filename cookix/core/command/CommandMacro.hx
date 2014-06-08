package cookix.core.command;

import haxe.ds.StringMap;
import haxe.macro.Context;
import cookix.tools.JsonParser;
import cookix.tools.ObjectDynamic;
import cookix.exceptions.NotFoundException;
import cookix.core.config.ConfigurationMacro;
import sys.io.File;
import haxe.macro.Compiler;
import cookix.tools.macro.MacroMetadataReader;
import cookix.tools.macro.ClassMetadata;
import cookix.tools.macro.Metadata;
import cookix.tools.macro.MetadataType;
import cookix.exceptions.InvalidArgumentException;
import cookix.tools.FolderReader;
import cookix.tools.console.CliException;
import cookix.tools.console.CommandReader;
import cookix.tools.console.Console;
import cookix.tools.Convert;

typedef CommandMetadata = {
    var name        : String;
    var description : String;
    var classPath   : String;
    var options     : Array<Option>; // Contains at least --help
    var callback    : String; // Name of the function which takes the value as a parameter
}

/**
 * Macro which builds commands configuration
 * @author Axel Anceau (Peekmo)
 */
class CommandMacro
{
    private static var commands : Array<{path : String, command : CommandMetadata}>;

    /**
     * Builds coommand's configuration and returns it
     * @return Commands
     */
    macro public static function getCommands()
    {
        if (null == commands) {
            commands = new Array<{path: String, command: CommandMetadata}>();
            trace('Generate commands container');

            generateCommands();
            FolderReader.createFile("application/exports/config/dump_commands.json", JsonParser.encode(commands));

            trace('Commands container generated');
        }

        return Context.makeExpr(commands, Context.currentPos());
    }

    /**
     * Generate the commands container by parsing annotations from all "commands" folders
     */
    private static function generateCommands() : Void
    {
        var content      : String        = File.getContent('application/config/bundles.json');
        var dependencies : ObjectDynamic = JsonParser.decode(content);


        for (dependency in dependencies.iterator()) {
            parsePackageCommand(Std.string(dependency));
        }
    }

    /**
     * Parse the given package's commands folder
     * @param  name : String Package name
     */
    private static function parsePackageCommand(name : String) : Void
    {
        #if macro
            var commandsDecoded : Array<String> = FolderReader.getClassesFromClassPath(name, "/commands");

            for (command in commandsDecoded.iterator()) {
                Compiler.include(command);

                try {
                    var metadata : ClassMetadata = MacroMetadataReader.getMetadata(command);
                    var commandCreated : CommandMetadata = parseMetadata(metadata);
                    commandCreated.classPath = command;

                    commands.push({path : command, command : commandCreated});
                } catch (ex: NotFoundException) {
                    throw new NotFoundException(command + ' : ' + ex.message);
                } catch (ex: InvalidArgumentException) {
                    throw new InvalidArgumentException(command + ' : ' + ex.message);
                }
            }
        #else
            throw "You can't parse package command from outside a macro";
        #end
    }

    /**
     * Parse class metadata to build the command container
     * @param  commandClass : ClassMetadata Service to parse
     * @return Command created
     */
    private static function parseMetadata(commandClass : ClassMetadata) : CommandMetadata
    {
        var command : CommandMetadata = parseCommandInfos(commandClass.global);
        command.options = parseCommandOptions(commandClass.global);

        return command;
    }

    /**
     * Get general informations from the command (name, description and callback if provided)
     * @param  serviceClass : Metadata      Command's globals metadata
     * @return Command
     */
    private static function parseCommandInfos(serviceClass : Metadata) : CommandMetadata
    {
        var declaration : MetadataType = null;

        try {
             declaration = serviceClass.get('Command'); 
        } catch (ex: NotFoundException) {
            throw new NotFoundException('@:Command declaration not found', false);
        }

        // If no value is given
        if (declaration.params.size() == 0) {
            throw new NotFoundException("Command name not found", false);
        }

        var name : ObjectDynamic = declaration.params[0];

        // An array or an object is not a valid name for a command
        if (name.isArray() || name.isObject()) {
            throw new InvalidArgumentException("Invalid command name, should be string", false);
        }
        
        // No description
        if (declaration.params.size() == 1) {
            throw new NotFoundException("Command description not found", false);
        }

        var description : ObjectDynamic = declaration.params[1];
        
        // An array or an object is not a valid description for a command
        if (description.isArray() || description.isObject()) {
            throw new InvalidArgumentException("Invalid command description, should be string", false);
        }
        
        var command : CommandMetadata = {
            name: Std.string(ConfigurationMacro.replace(name)),
            description: Std.string(ConfigurationMacro.replace(description)),
            classPath: null,
            callback: null,
            options: new Array<Option>()
        };

        // If there's additionals informations
        if (declaration.params.size() == 3) {
            var additional : ObjectDynamic = declaration.params[2];

            if (!additional.isObject()) {
                throw new InvalidArgumentException("Third parameter must be an object", false);
            }

            if (additional.has("callback")) {
                command.callback = Std.string(additional['callback']);
            }
        }

        return command;
    }

    /**
     * Get command's options (if provided) (name, description, callback, value)
     * @param  serviceClass : Metadata Command's globals metadata
     * @return All options provided
     */
    private static function parseCommandOptions(serviceClass : Metadata) : Array<Option>
    {
        var declarations : Array<MetadataType> = serviceClass.getAll('Option');
        
        var options : Array<Option> = new Array<Option>();

        for (declaration in declarations.iterator()) {
            // If no value is given
            if (declaration.params.size() == 0) {
                throw new NotFoundException("Option name not found", false);
            }

            var name : ObjectDynamic = declaration.params[0];

            // An array or an object is not a valid name for a command
            if (name.isArray() || name.isObject()) {
                throw new InvalidArgumentException("Invalid option name, should be string", false);
            }
            
            // No description
            if (declaration.params.size() == 1) {
                throw new NotFoundException("Option description not found", false);
            }

            var description : ObjectDynamic = declaration.params[1];
        
            // An array or an object is not a valid description for a command
            if (description.isArray() || description.isObject()) {
                throw new InvalidArgumentException("Invalid command description, should be string", false);
            }

            var option : Option = {
                name: Std.string(ConfigurationMacro.replace(name)),
                description: Std.string(ConfigurationMacro.replace(description)),
                valueMandatory: false,
                valueDescription: null,
                callback: null
            };

            // If there's additionals informations
            if (declaration.params.size() == 3) {
                var additional : ObjectDynamic = declaration.params[2];

                if (!additional.isObject()) {
                    throw new InvalidArgumentException("Third parameter must be an object", false);
                }

                if (additional.has("callback")) {
                    option.callback = Std.string(additional['callback']);
                }

                if (additional.has("valueMandatory")) {
                    option.valueMandatory = Convert.bool(additional['valueMandatory']);

                    if (!additional.has("valueDescription")) {
                        throw new NotFoundException('Option $name : You have to provide a description for a mandatory value');
                    }

                    option.valueDescription = Std.string(additional['valueDescription']);
                }
            }

            options.push(option);
        }

        return options;
    }
}