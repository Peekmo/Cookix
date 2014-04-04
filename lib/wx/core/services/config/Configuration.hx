package wx.core.services.config;

import wx.tools.ObjectDynamic;
import wx.core.config.ConfigurationMacro;

/**
 * Configuration checker
 * @author Axel Anceau (Peekmo)
 */
@:Service("woox.configuration")
@:Parameters("a", "b")
class Configuration
{
    /**
     * @var ObjectDynamic: configuration Application's configuration built with the macro
     */
    public var configuration(null, null) : ObjectDynamic;

    /**
     * Constructor
     * Gets configuration from macro
     */
    public function new()
    {
        this.configuration = ConfigurationMacro.getConfiguration();
    }

    /**
     * Get application's configuration ptions
     * @return ObjectDynamic
     */
    @:Tag({name:"ok", type:"event"})
    @:Tag({name:"ok3", type:"event"})
    public function getConfiguration() : ObjectDynamic
    {
        return this.configuration;
    }

    @:Tag({name:"ok2", type:"event"})
    public function test() : String
    {
        return "ok";
    }
}