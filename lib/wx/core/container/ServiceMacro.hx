package wx.core.container;

import haxe.macro.Context;
import wx.tools.JsonDynamic;
import wx.tools.JsonParser;
import wx.tools.StringMapWX;
import wx.exceptions.NotFoundException;
import wx.exceptions.FileNotFoundException;
import wx.core.config.ConfigurationMacro;

/**
 * Parse services's files and create the service container
 * @x@ is a service
 * %x% is a parameter from parameters
 * @author Axel Anceau (Peekmo)
 */
class ServiceMacro 
{
    /**
     * Full application's configuration
     */
    private static var configuration : JsonDynamic;

    /**
     * Full application's services
     */
    private static var services : JsonDynamic;

    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getServices()
    {
        if (null == services) {
            configuration = ConfigurationMacro.getConfiguration();

            trace('Generating service container...');

            services = getServicesConfiguration();

            trace('Service container generated');
        }

        return Context.makeExpr(services, Context.currentPos());
    }

    /**
     * Get internal services configuration
     * @return JsonDynamic
     */
    private static function getServicesConfiguration() : JsonDynamic
    {
        try {
            var content : String = sys.io.File.getContent('application/config/bundles.json');

            var libs : JsonDynamic = JsonParser.decode(content);
            var final : JsonDynamic = {};

            // Get config.json from each internal bundles
            for (i in libs['internals'].iterator()) {
                var folder : String = Std.string(libs['internals'][i]).split('.').join('/');
                var services : String = sys.io.File.getContent('src/' + folder + '/config/services.json');

                final.merge(replace(JsonParser.decode(services)));
            }

            // Get config.json from each external bundles
            for (i in libs['externals'].iterator()) {
                var folder : String = Std.string(libs['externals'][i]).split('.').join('/');
                var services : String = sys.io.File.getContent('lib/' + folder + '/config/services.json');

                final.merge(replace(JsonParser.decode(services)));
            }

            return final;
        } catch (ex: String) {
            throw new FileNotFoundException('No bundles configuration found (' + ex.split(':')[0] +')');
        }
    }

    /**
     * Replaces the services options with configuration values
     * @param  services: JsonDynamic Services's config file
     * @return           Config replaced
     */
    private static function replace(services: JsonDynamic) : JsonDynamic
    {
        // Get service's parameters defined
        var parameters : JsonDynamic = getParameters(services['parameters']);

        // Loop on services to dding them into global service's container (if there's services)
        if (!services.isObject() || !services['services'].isArray()) {
            return null;
        }

        var servConfiguration : JsonDynamic = {};
        for (i in services['services'].iterator()) {
            var service = services['services'][i];

            if (null == service['id'] || null == service['class']) {
                throw new NotFoundException('A service without id has been found');
            }

            var config : JsonDynamic = { 
                service: service['class'], 
                parameters : service['parameters']
            };


            // Replaces service's parameters
            for (z in config['parameters'].iterator()) {
                var key : String = Std.string(config['parameters'][z]);
                if (key.charAt(0) == '%' && key.charAt(key.length - 1) == '%') {
                    var value : String = Std.string(config['parameters'][i]).substr(1, Std.string(config['parameters'][i]).length - 2);

                    if (parameters.has(value)) {
                        config['parameters'][i] = parameters[value];
                    } else {
                        throw new NotFoundException('Parameter '+ value +' does not exists');
                    }
                }
            }

            if (null == config['parameters']) {
                config.delete('parameters');
            }

            // trace(Std.string(service['class']));
            // var test = Type.createEmptyInstance(Type.resolveClass(Std.string(service['class'])));
            servConfiguration[Std.string(service['id'])] = config;
        }

        return servConfiguration;
    }

    /**
     * Get parameters from a services's file
     * @param  parameters: JsonDynamic   Parameters
     * @return             JsonDynamic
     */
    private static function getParameters(parameters: JsonDynamic) : JsonDynamic
    {
        for (i in parameters.iterator()) {
            if (parameters[i].isArray() || parameters[i].isObject()) {
                parameters[i] = getParameters(parameters[i]);

            } else if (Std.string(parameters[i]).charAt(0) == '%') {
                var value : String = Std.string(parameters[i]).substr(1, Std.string(parameters[i]).length - 2);

                var elements : Array<String> = value.split('.');

                var current : JsonDynamic = configuration;
                for (key in elements.iterator()) {
                    if (current.has(key)) {
                        current = current[key];
                    } else {
                        throw new NotFoundException('The key '+ key +' has not been found in configuration\'s file');
                    }
                }

                parameters[i] = current;
            }
        }

        return parameters;
    }
}