package ;

import cookix.tools.FolderReader;

/**
 * Helps to generate a new Cookix project
 * @author Axel Anceau (Peekmo)
 */
class ProjectBuilder
{
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
	 * @param  ?name : String Project's name (optional, will be asked if missing)
	 */
	public function new (?name : String) : Void
	{
		if (null != name) {
			this.name = name;
		}
	}

	/**
	 * Build process
	 */
	public function build() : Void
	{
		if (null == this.name) {
			while (this.name == null || this.name == "") {
				Sys.print("Please, enter a name for your project : ");
				this.name = Sys.stdin().readLine();
			} 
		}

		FolderReader.createFile(this.name + "/application/boot.hx", 
"
import cookix.core.http.request.Request;
import cookix.core.Kernel;

/**
 * Main of the application
 * @author Axel Anceau (Peekmo)
 */
class Boot
{
    /**
     * Application's entry point
     */
    public static function main()
    {
        var request = Request.create();
        Kernel.handle(request);
    }
}
"
		 );
	}
}