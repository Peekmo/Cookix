package ;

import cookix.tools.FolderReader;

/**
 * Helps to generate a new Cookix project
 * @author Axel Anceau (Peekmo)
 */
class ProjectBuilder
{
	/**
	 * @var userDir : String Current user's directory
	 */
	public var userDir : String;

	/**
	 * @var name : String Project's name
	 */
	public var name : String;

	/**
	 * @var namespace : String Project's namespace
	 */
	public var namespace : String;

	/**
	 * Project's constructor
	 * @param  userDir : String Current user's directory
	 * @param  name    : String Project's name
	 */
	public function new (userDir : String, name : String) : Void
	{
		this.name    = name;
		this.userDir = userDir;
	}

	/**
	 * Build process
	 */
	public function build() : Void
	{
		FolderReader.copyFileSystem(Sys.getCwd() + "script/templates/base", this.userDir + this.name);
	}
}