package commands;

import cookix.tools.console.AbstractCommand;
import cookix.tools.console.ICommand;
import cookix.tools.FolderReader;
using cookix.tools.ds.StringMapTools;

/**
 * Command to globally manage a project
 * @author Axel Anceau (Peekmo)
 */
class Project extends AbstractCommand implements ICommand
{
	/**
	 * Method called by the command container
	 */
	public function execute() : Void
	{
		if (this.options.size() == 0) {
			this.help();
		}
	}

	/**
	 * Creates a new project
	 * @param  ?name : String Name of the project to create (folder's name)
	 */
	public function create(name : String) : Void
	{
		this.writeln('Creating project $name ...');
		FolderReader.copyFileSystem(Sys.getCwd() + "script/templates/base", this.userDir + name);
		this.writeln("Project successfully created");
	}
}