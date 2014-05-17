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

/**
 * Macro which builds commands configuration
 * @author Axel Anceau (Peekmo)
 */
class CommandMacro
{
	private static var commands : Array<{path : String, command : Command}>;

	/**
	 * Builds coommand's configuration and returns it
	 * @return Commands
	 */
	macro public static function getCommands()
	{
		if (null == commands) {
			commands = new Array<{path: String, command: Command}>();
			trace('Generate commands container');

			generateCommands();

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
                    var commandCreated : Command = parseMetadata(metadata);

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
    private static function parseMetadata(commandClass : ClassMetadata) : Command
    {
        var command : Command = parseCommandInfos(commandClass.global, commandClass);
        // command.options = parseCommandOptions(commandClass.global);

        return command;
    }

    /**
     * Get general informations from the command (name, description and callback if provided)
     * @param  serviceClass : Metadata      Command's globals metadata
     * @param  commandClass : ClassMetadata Command class' metadata
     * @return Command
     */
    private static function parseCommandInfos(serviceClass : Metadata, commandClass : ClassMetadata) : Command
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
        
        var command : Command = {
        	name: Std.string(ConfigurationMacro.replace(name)),
        	description: Std.string(ConfigurationMacro.replace(description)),
        	callback: null,
        	options: null
        };

        // If there's additionals informations
        if (declaration.params.size() == 3) {
        	var additional : ObjectDynamic = declaration.params[2];

        	if (!additional.isObject()) {
        		throw new InvalidArgumentException("Third parameter must be an object", false);
        	}

        	if (additional.has("callback")) {
        		command.callback = commandClass.getMethod(Std.string(additional["callback"]));
        	}
        }

        var description : ObjectDynamic = declaration.params[1];


        return command;
    }

    /**
     * Get command's options (if provided) (name, description, callback, value)
     * @param  serviceClass : Metadata Command's globals metadata
     * @return All options provided
     */
    private static function parseCommandOptions(serviceClass : Metadata) : StringMap<Option>
    {
    	return null;
    }
}