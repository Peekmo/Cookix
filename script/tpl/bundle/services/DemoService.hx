package #namespace#.services;

import cookix.core.services.config.Configuration;

/**
 * Demo service class
 * @author Axel Anceau
 */
@:service('#vendor#.demoService')
@:parameters("%general.env%", "@cookix.configuration")
class DemoService
{
    /**
     * @var iString: String Injected parameter
     */
    public var iString(null,null) : String;

    /**
     * @var cookix.core.config.Configuration Service injected
     */
    public var configService(null, null): Configuration;

    /**
     * Constructor used for dependency injection
     * @param  iString: String        Parameter injected
     * @param  config:  Configuration Configuration's service injected
     */
    public function new(iString: String, config: Configuration)
    {
        this.iString = iString;
        this.configService = config;
    }

    public function demo() : Void
    {
        // Print your environment
        trace(this.configService.get('general.env'));
    }
}
