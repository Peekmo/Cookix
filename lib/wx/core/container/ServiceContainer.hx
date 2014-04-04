package wx.core.container;

import wx.tools.StringMapWX;
import wx.tools.ObjectDynamic;
import wx.core.events.Subscriber;

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
    private static var instanciations(null, null) : StringMapWX<Dynamic> = new StringMapWX<Dynamic>();

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
        if ('wx.container' == service) {
            return new Service();
        }

        if (!instanciations.exists(service) && !services.has(service)) {
            throw new wx.exceptions.NotFoundException('Service not found : '+ service);
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
        if (services[service].has('parameters')) {
            for (s in services[service]['parameters'].iterator()) {
                var key : String = Std.string(services[service]['parameters'][s]);
                if (key.charAt(0) == '@' && key.charAt(key.length - 1) == '@') {
                    var value : String = Std.string(services[service]['parameters'][s]).substr(1, Std.string(services[service]['parameters'][s]).length - 2);

                    var serviceParameter : Dynamic = get(value);
                    parameters.push(serviceParameter);
                } else {
                    parameters.push(services[service]['parameters'][s]);
                }
            }
        }

        var inst : Dynamic = Type.createInstance(Type.resolveClass(Std.string(services[service]['service'])), parameters);

        instanciations.set(service, inst);
        return inst;
    }

    /**
     * Get tags from the given type
     * @param  ?type: String        Type of events required
     * @return     Tag list
     */
    public static function getTags(?type: String) : ObjectDynamic
    {
        if (null == type) {
            return tags;
        }

        return tags[type];
    }

    /**
     * Initialize the service container with the macro
     */
    public static function initialization()
    {
        services = ServiceMacro.getServices();
        tags = ServiceMacro.getTags();
    }
}