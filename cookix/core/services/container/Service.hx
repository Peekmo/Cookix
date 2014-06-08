package cookix.core.services.container;

import cookix.tools.ObjectDynamic;
import cookix.core.container.TagType;
import cookix.core.container.ServiceContainer;

/**
 * Service container toolkit
 * @author Axel Anceau (Peekmo)
 */
@:Service('cookix.container')
class Service
{
    /**
     * Constructor
     */
    public function new() 
    {

    }

    /**
     * Returns the required service identified by its name from ServiceContainer
     * @param  service: String        Service's name
     * @return          The service
     */
    public inline function get(service: String) : Dynamic
    {
        return ServiceContainer.get(service);
    }

    /**
     * Get tags from the given type
     * @param  name:  String  Tag name
     * @param  ?type: String  Type of events required
     * @return     Tag list
     */
    public inline function getTags(name: String, ?type : String) : Array<TagType>
    {
        return ServiceContainer.getTags(name, type);
    }
}