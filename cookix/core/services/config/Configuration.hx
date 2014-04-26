package cookix.core.services.config;

import cookix.tools.ObjectDynamic;
import cookix.core.config.ConfigurationMacro;
import cookix.exceptions.NotFoundException;

/**
 * Configuration checker
 * @author Axel Anceau (Peekmo)
 */
@:Service("cookix.configuration")
class Configuration
{
    /**
     * @var ObjectDynamic: configuration Application's configuration built with the macro
     */
    public var configuration(null, null) : ObjectDynamic;

    /**
     * @var planeConfiguration : Map<String, ObjectDynamic> Plane representation of application's config
     */
    public var planeConfiguration : ObjectDynamic;

    /**
     * Constructor
     * Gets configuration from macro
     */
    public function new()
    {
        this.configuration      = ConfigurationMacro.getConfiguration();
        this.planeConfiguration = ConfigurationMacro.getPlaneConfiguration();
    }

    /**
     * Get application's configuration ptions
     * @return ObjectDynamic
     */
    public function getConfiguration() : ObjectDynamic
    {
        return this.configuration;
    }

    /**
     * Gets the value of a parameter (each "." represents an object attribute and [] an array)
     * @param  name : String Full string of the param
     * @return Parameter's value
     */
    public function get(name : String) : ObjectDynamic
    {
        if (this.planeConfiguration.has(name)) {
            return this.planeConfiguration[name];
        } else {
            throw new NotFoundException('Parameter '+ name +' does not exists');
        }
    }
}