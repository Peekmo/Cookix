package wx.core.container;

import wx.tools.StringMapWX;

/**
 * Service container
 * @author Axel Anceau (Peekmo)
 */
class ServiceContainer
{
    /**
     * Container of all services uninstanciated
     */
    private static var services : JsonDynamic;

    /**
     * Returns the required service identified by its name
     * @param  service: String        Service's name
     * @return          The service
     */
    public static function get(service: String) : Dynamic
    {
        if (!services.exists(service)) {
            throw new wx.exceptions.NotFoundException('Service not found : '+ service);
        }

        return this.services.get(service);
    }

    /**
     * Initialize the service container with the macro
     */
    @:macro public static function initialization()
    {
        services = ServiceMacro.getServices();
    }
}