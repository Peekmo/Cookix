package wx.core.container;

import wx.tools.JsonDynamic;

/**
 * Service container toolkit
 * @author Axel Anceau (Peekmo)
 */
class Service
{
    /**
     * Constructor
     */
    public function new() 
    {
        ServiceContainer.initialization();
    }

    /**
     * Returns the required service identified by its name from ServiceContainer
     * @param  service: String        Service's name
     * @return          The service
     */
    public function get(service: String) : Dynamic
    {
        return ServiceContainer.get(service);
    }

    /**
     * Get tags from the given type
     * @param  ?type: String        Type of events required
     * @return     Tag list
     */
    public function getTags(?type : String) : JsonDynamic
    {
        return ServiceContainer.getTags(type);
    }
}