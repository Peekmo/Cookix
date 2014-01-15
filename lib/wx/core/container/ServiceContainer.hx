package wx.core.container;

import wx.tools.StringMapWX;

/**
 * Service container
 * @author Axel Anceau (Peekmo)
 */
class ServiceContainer
{
    private var services : JsonDynamic;

    /**
     * Constructor
     */
    public function new()
    {
        this.services = {};
    }

    /**
     * Returns the required service identified by its name
     * @param  service: String        Service's name
     * @return          The service
     */
    public function get(service: String) : Dynamic
    {
        if (!services.exists(service)) {
            throw new wx.exceptions.NotFoundException('Service not found : '+ service);
        }

        return this.services.get(service);
    }

    /**
     * Register a new service in the container
     * @param  service:  String        Service's name
     * @param  oService: Dynamic       Service instance
     */
    public function set(service: String, oService: Dynamic) : Void
    {
        if (services.exists(service)) {
            throw new wx.exceptions.NotFoundException('Service name already exists : '+ service);
        }

        this.services.set(service, oService);
    }
}