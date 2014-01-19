package wx.demo.services;

/**
 * Demo service class
 * @author Axel Anceau
 */
@:keep class DemoService
{
    /**
     * @var iString: String Injected parameter
     */
    public var iString(null,null) : String;

    /**
     * @var wx.core.config.Configuration Service injected
     */
    public var configService(null, null): wx.core.config.Configuration;

    /**
     * Constructor used for dependency injection
     * @param  iString: String        Parameter injected
     */
    public function new(iString: String, config: wx.core.config.Configuration)
    {
        this.iString = iString;
        this.configService = config;
        trace(this.iString);
    }

    public function test()
    {
        trace(this.configService.getConfiguration());
        trace('test');
    }
}