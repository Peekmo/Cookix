package ;

/**
 * Run script for haxelib
 * @author Axel Anceau (Peekmo)
 */
class RunScript
{
	/**
	 * Entry point
	 */
	public static function main() : Void
	{
		var args : Array<String> = Sys.args();

		if (args.length == 0) {
			Sys.println("Cookix : Missing argument /!\\ Use --help to get available commands");
			return;
		}

		var command : String = args[0];

		if (args[0] == "--help") {
			printHelp();
		} else if (args[0] == "--new") {
			var name : String = null;
			if (args.length > 1) {
				name = args[1];
			}

			var project : ProjectBuilder = new ProjectBuilder(name);
			project.build();
		}
	}

	/**
	 * Prints available commands to the user
	 */
	public static function printHelp() : Void
	{
		Sys.println("Cookix - Available commands");
		Sys.println("--new <project name> to create a new project");
	}
}