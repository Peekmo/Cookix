package ;

import haxe.ds.StringMap;

typedef Command = {
	var name            		    : String;
	var description     		    : String;
	var hasValue                    : Bool;
	var callback                    : ?String->Void; // Function which takes the value as a parameter
	@:optional var valueMandatory   : Bool;
	@:optional var valueDescription : String;
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
	 * @param  command : Command Command to add
	 */
	public static function push(command : Command) : Void
	{
		if (command.valueDescription == null && command.hasValue) {
			throw command.name + " : A command with a value, must have a description for its value";
		}

		if (command.valueMandatory == true && !command.hasValue) {
			throw command.name + " : The command doesn't expect a value, but this value is mandatory ?";
		}

		if (command.valueMandatory == null) {
			command.valueMandatory = false;
		}

		commands.set(command.name, command);
	}

	/**
	 * Checks all commands received and call their callback
	 */
	public static function check() : Void
	{
		for (option in Console.options.keys()) {
			if (!commands.exists(option)) {
				throw new CliException("Command not found : " + option);
			}

			var command : Command = commands.get(option);

			if (command.valueMandatory && Console.options.get(option) == null) {
				throw new CliException("A value is mandatory for this command : " + option);
			}

			command.callback(Console.options.get(option));
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