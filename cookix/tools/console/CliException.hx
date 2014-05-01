package cookix.tools.console;

/**
 * Basic exception for the command line
 * @author Axel Anceau (Peekmo)
 */
class CliException
{
	/**
	 * @var message : String Exception's message
	 */
	public var message : String;

	/**
	 * @var command : String Command name where the error come from
	 */
	public var command : String;

	/**
	 * Constructor
	 * @param  message : String Message to show to the user
	 */
	public function new(message : String, ?command : String) 
	{
		this.message = message;
		this.command = command;
	}
}