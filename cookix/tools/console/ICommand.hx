package cookix.tools.console;

/**
 * Command interface
 * @author Axel Anceau (Peekmo)
 */
interface ICommand
{
	/**
	 * Method called by the command container
	 */
  	public function execute() : Void;
}