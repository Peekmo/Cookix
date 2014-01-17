package wx.demo.services;

/**
 * Demo service class
 * @author Axel Anceau
 */
class DemoService
{
    /**
     * @var iString: String Injected parameter
     */
    public var iString(null,null) : String;

    /**
     * Constructor used for dependency injection
     * @param  iString: String        Parameter injected
     */
    public function new(iString: String)
    {
        this.iString = iString;
        trace(this.iString);
    }

    public function test()
    {
        trace('test');
    }
}