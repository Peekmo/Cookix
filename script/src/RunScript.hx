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
		try {
			createCommands();
			Console.initialization();

			CommandReader.check();
		} catch (ex : CliException) {
			Sys.println("ERROR => " + ex.message);
			Sys.println("");
			Console.showHelp();
		}
	}

	/**
	 * Fill the CommandReader with all commands allowed
	 */
	public static function createCommands() : Void
	{
		CommandReader.push({
			name: "help", 
			description: "Prints command's lists", 
			hasValue: false,
			callback: function(?value : String) {
				Console.showHelp();
			}
		});

		CommandReader.push({
			name: "project", 
			description: "Creates a new cookix project", 
			hasValue: true,
			valueMandatory: true,
			valueDescription: "project-name",
			callback: function(?value: String) {
				var project : ProjectBuilder = new ProjectBuilder(Console.userDir, value);
				project.build();
				Sys.println("The project has been successfully created.");
			}
		});
	}
}