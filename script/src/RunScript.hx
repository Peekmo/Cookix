package ;

import cookix.tools.console.CommandReader;
import cookix.tools.console.CliException;
import cookix.tools.console.Console;
import haxe.ds.StringMap;

// Commands to import !
import commands.Help;
import commands.Project;

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
			classPath: 'commands.Help'
		});

		CommandReader.push(
			{
				name: "project", 
				description: "Manage a cookix project",
				classPath: 'commands.Project'
			},
			[
				{
					name: "new",
					description: "Creates a new project",
					valueMandatory: true,
					valueDescription: "project-name",
					callback: 'create'
				} 
			]
		);
	}
}