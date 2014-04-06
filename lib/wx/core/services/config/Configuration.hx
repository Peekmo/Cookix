package wx.core.services.config;

import wx.tools.ObjectDynamic;
import wx.core.config.ConfigurationMacro;

/**
 * Configuration checker
 * @author Axel Anceau (Peekmo)
 */
@:Service("wx.configuration")
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
    public function getConfiguration() : ObjectDynamic
    {
        return this.configuration;
    }
}