package cookix.tools.console;

import haxe.ds.StringMap;
import sys.io.Process;
using StringTools;

/**
 * Simple console manager for CLI
 * @author Axel Anceau (Peekmo)
 */
class Console
{
	/**
	 * @var args: Array<String> Args received from the command
	 */
	public static var args(default, null) : Array<String>;

	/**
	 * @var command : String Command launched
	 */
	public static var command(default, null): String;

	/**
	 * @var options: StringMap<String> Options from command line (e.g : --new) 
	 */
	public static var options(default, null): StringMap<String>;

	/**
	 * @var userDir : String User's folder
	 */
	public static var userDir : String;

	/**
	 * Init the class
	 */
	public static function initialization() : Void
	{
		args    = Sys.args();
		options = new StringMap<String>();

		if (isHaxelibRun()) {
			userDir = args.pop();
		} else {
			userDir = Sys.getCwd();
		}

		if (args.length == 0) {
			throw new CliException("You need to provide some arguments");
		}

		command = args.shift();

		var previous : String = "";
		for (arg in args.iterator()) {
			if (arg.startsWith("--")) {
				previous = arg.substr(2);
				options.set(previous, null);
			} else {
				if (previous == "") {
					throw new CliException("Invalid option", command);
				} else {
					options.set(previous, arg);
					previous = "";
				}
			}
		}
	}

	/**
	 * Checks if the command has been launch with "haxelib run cookix"
	 * From flixel-tools
	 * @return Yes or no :D
	 */
	private static function isHaxelibRun() : Bool
	{
		var proc   : Process = new Process("haxelib", ["path", "cookix"]);
		var result : String = "";

		try {
			var previous:String = "";

			while (true) {
				var line:String = proc.stdout.readLine();
				if (line == "-D " + "cookix") {
					result = previous;
					break;
				}

				previous = line;
			}
		}

		catch (e:Dynamic) { };
		proc.close();

		return Sys.getCwd() == result;
	}

	/**
	 * Show available commands by parsing CommandReader's commands
	 * @param ?commandName : String If specified, print help for the given command only 
	 */
	public static function showHelp(?commandName : String) : Void
	{
		if (commandName != null) {
			var command = CommandReader.commands.get(commandName);

			writeln("Command >> " + command.name + " << : " + command.description);
			writeln("");
			writeln("Available options : ");

			for (option in command.options.iterator()) {
				var show : String = "--" + option.name; 
				
				if (option.valueDescription != null) {
					show += " <" + option.valueDescription + ">";

					if (!option.valueMandatory) {
						show += " (optional)";
					}
				}

				show += " : " + option.description;

				writeln(show);
			}
		} else {
			writeln("Available commands (type <command> --help to get the given command options) : ");
			writeln("");

			for (command in CommandReader.commands.iterator()) {
				writeln("=> " + command.name + " - " + command.description);
			}
		}
	}

	/**
	 * Write a message, without a new line
	 * @param  message : String Message to write
	 */
	public static inline function write(message : String) : Void
	{
		Sys.print(message);
	}
	
	/**
	 * Write a message with a new line
	 * @param  message : String Message to print
	 */
	public static inline function writeln(message : String) : Void
	{
		Sys.println(message);
	}
}