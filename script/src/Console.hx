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

		if (Sys.args().length == 0) {
			throw new CliException("You need to provide some arguments");
		}

		if (isHaxelibRun()) {
			userDir = args.pop();
		} else {
			userDir = Sys.getCwd();
		}

		var previous : String = "";
		for (arg in args.iterator()) {
			if (arg.startsWith("--")) {
				previous = arg.substr(2);
				options.set(previous, null);
			} else {
				if (previous == "") {
					throw new CliException("Invalid argument");
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
	 */
	public static function showHelp() : Void
	{
		Sys.println("Available commands : ");
		
		for (command in CommandReader.commands.iterator()) {
			var show : String = "--" + command.name; 
			
			if (command.hasValue) {
				show += " <" + command.valueDescription + ">";

				if (!command.valueMandatory) {
					show += " (optional)";
				}
			}

			show += " : " + command.description;

			Sys.println(show);
		}
	}
}