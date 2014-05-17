package cookix.tools.console;

import haxe.ds.StringMap;

/**
 * Class to extend to get commands tools
 * @author Axel Anceau (Peekmo)
 */
class AbstractCommand
{
	/**
	 * @var options Options specified in the given command (filled during initialization)
	 */
	public var options : StringMap<String>;

	/**
	 * @var userDir Current user's directory
	 */
	public var userDir : String;

	/**
	 * Write a message to the standard output with a new line
	 * @param  message : String Message to print
	 */
	public function writeln(message : String) : Void 
	{
		Console.writeln(message);
	}

	/**
	 * Write a simple message to the standard output
	 * @param  message : String Message to write
	 */
	public function write(message: String) : Void 
	{
		Console.write(message);
	}

	/**
	 * Get the value of the given input option
	 * @param  name : String Option's name
	 * @return Its value (if exists) - null if it doesn't
	 */
	public function getOption(name : String) : String
	{
		if (!this.options.exists(name)) {
			return null;
		}

		return this.options.get(name);
	}

	/**
	 * Print help to the current command to the user
	 */
	public function help(?value : String) : Void
	{
		Console.showHelp(Console.command);
	}

	/**
	 * Method called by the container to fill options
	 */
	public function _initialization_() : Void
	{
		this.options = Console.options;
		this.userDir = Console.userDir;
	}
}