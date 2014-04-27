
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
	 * Constructor
	 * @param  message : String Message to show to the user
	 */
	public function new(message : String) 
	{
		this.message = message;
	}
}