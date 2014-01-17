package wx.core.container;

import wx.tools.StringMapWX;
import wx.tools.JsonDynamic;

/**
 * Service container
 * @author Axel Anceau (Peekmo)
 */
class ServiceContainer
{
    /**
     * Container of all services uninstanciated
     */
    private static var services(null, null) : JsonDynamic;

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
        var parameters : Array<String> = cast services[service]['parameters'];
        var inst : Dynamic = Type.createInstance(Type.resolveClass(Std.string(services[service]['service'])), parameters);

        instanciations.set(service, inst);
        return inst;
    }

    /**
     * Initialize the service container with the macro
     */
    public static function initialization()
    {
        services = ServiceMacro.getServices();
    }
}