package wx.core.container;

import wx.tools.StringMapWX;
import wx.tools.JsonDynamic;
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
    public static var services(default, default) : JsonDynamic;

    /**
     * Container of all services instanciated
     */
    private static var instanciations(null, null) : StringMapWX<Dynamic> = new StringMapWX<Dynamic>();

    /**
     * Returns the required service identified by its name
     * @param  service: String        Service's name
     * @return          The service
     */
    public static function get(service: String) : Dynamic
    {
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
     * Gets all subscribers to the given tag
     * @param  tag: String        Event's tag
     * @return      Array<String>
     */
    public function getSubscribers(type: String, tag: String) : Array<Subscriber>
    {
        var subscribers : Array<Subscriber> = new Array<Subscriber>();

        for (service in services.iterator()) {
            if (services[service].has('tags')) {
                var tags = services[service]['tags'];
                for (i in tags) {
                    if (tags['type'] == type && tags['tag'] == tag) {
                        subscribers.push({
                            service: cast services[service]['class'],
                            method: cast tags['method']
                        });
                    }
                }
            }
        }

        return subscribers;
    }

    /**
     * Initialize the service container with the macro
     */
    public static function initialization()
    {
        services = ServiceMacro.getServices();
    }
}