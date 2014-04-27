package cookix.core.container;

import cookix.tools.ObjectDynamic;
import cookix.core.container.TagType;
import haxe.ds.StringMap;

/**
 * Service container
 * @author Axel Anceau (Peekmo)
 */
class ServiceContainer
{
    /**
     * Container of all services uninstanciated
     */
    public static var services(default, default) : ObjectDynamic;

    /**
     * Container of all services instanciated
     */
    private static var instanciations(null, null) : StringMap<Dynamic> = new StringMap<Dynamic>();

    /**
     * Services tags
     */
    public static var tags(default, default) : ObjectDynamic;

    /**
     * Returns the required service identified by its name
     * @param  service: String        Service's name
     * @return          The service
     */
    public static function get(service: String) : Dynamic
    {
        if (!instanciations.exists(service) && !services.has(service)) {
            throw new cookix.exceptions.NotFoundException('Service not found : '+ service);
        }

        if (instanciations.exists(service)) {
            return instanciations.get(service);
        } else {
            return instanciate(service);
        }
    }

    /**
     * Instanciates the given class
     * @param  service: String        Service's name
     * @return          The given service instanciation
     */
    private static function instanciate(service: String) : Dynamic
    {
        var parameters : Array<Dynamic> = new Array<Dynamic>();

        // Iterate through parameters to build the parameter's array
        for (param in services[service]['parameters'].iterator()) {
            var key : String = Std.string(param);
            if (key.charAt(0) == '@') {
                var value : String = Std.string(param).substr(1, Std.string(param).length - 1);

                var serviceParameter : Dynamic = get(value);
                parameters.push(serviceParameter);
            } else {
                parameters.push(param);
            }
        }

        var inst : Dynamic = Type.createInstance(Type.resolveClass(Std.string(services[service]['namespace'])), parameters);
        instanciations.set(service, inst);
        return inst;
    }

    /**
     * Get tags from the given type
     * @param  ?type: String        Type of events required
     * @return     Tag list
     */
    public static function getTags(name : String, ?type: String) : Array<TagType>
    {
        var currentTags : Array<TagType> = cast tags[name];

        if (null != type && null != currentTags) {
            var finalTags : Array<TagType> = Reflect.copy(currentTags);

            for (tag in finalTags.iterator()) {
                if (tag.type != type) {
                    currentTags.remove(tag);
                }
            }
        }

        return null != currentTags ? currentTags : new Array<TagType>();
    }

    /**
     * Initialize the service container with the macro
     */
    public static function __init__()
    {
        services = ServiceMacro.getServices();
        tags     = ServiceMacro.getTags();
    }
}

