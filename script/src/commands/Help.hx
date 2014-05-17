package commands;

import cookix.tools.console.AbstractCommand;
import cookix.tools.console.ICommand;

/**
 * Command to print help
 * @author Axel Anceau (Peekmo)
 */
class Help extends AbstractCommand implements ICommand
{
	/**
	 * Method called by the command container
	 * Print commands list
	 */
	public function execute() : Void 
	{
		cookix.tools.console.Console.showHelp();
	}
}