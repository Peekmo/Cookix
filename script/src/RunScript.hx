package ;

import cookix.tools.console.CommandReader;
import cookix.tools.console.CliException;
import cookix.tools.console.Console;
import haxe.ds.StringMap;
using cookix.tools.ds.StringMapTools;

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

			CommandReader.call();
		} catch (ex : CliException) {
			Console.writeln("ERROR => " + ex.message);
			Console.writeln("");
			Console.showHelp(ex.command);
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
			callback: function(?values : StringMap<String>) {
				if (values.size() == 0) {
					Console.showHelp();
				}
			}
		});

		CommandReader.push(
			{
				name: "project", 
				description: "Manage a cookix project",
				callback: function(?values : StringMap<String>) {
					if (values.size() == 0) {
						Console.showHelp("project");
					}
				}
			},
			[
				{
					name: "new",
					description: "Creates a new project",
					valueMandatory: true,
					valueDescription: "project-name",
					callback: function(?value: String) {
						var project : ProjectBuilder = new ProjectBuilder(Console.userDir, value);
						project.build();
						Sys.println("The project has been successfully created.");
					}
				} 
			]
		);
	}
}