package wx.core.routing;

import haxe.macro.Context;
import wx.tools.JsonDynamic;
import wx.tools.JsonParser;
import wx.tools.StringMapWX;
import wx.exceptions.NotFoundException;
import wx.exceptions.FileNotFoundException;
import wx.exceptions.InvalidArgumentException;
import wx.core.config.ConfigurationMacro;

/**
 * Macro class to load routing files
 * @author Axel Anceau (Peekmo)
 */
class RoutingMacro 
{
    /**
     * @var configuration: JsonDynamic Application's configuration
     */
    private static var configuration : JsonDynamic;

    /**
     * @var routes: JsonDynamic Routes generated
     */
    private static var routes : JsonDynamic;

    /**
     * Builds routes json during Compilation
     * @return Services
     */
    macro public static function getRoutes()
    {
        if (null == routes) {
            configuration = ConfigurationMacro.getConfiguration();

            trace('Generating routes container...');

            routes = cast getRoutesConfiguration();

            trace('Routes container generated');
        }

        return Context.makeExpr(routes, Context.currentPos());
    }

    /**
     * Get routes configuration
     * @return JsonDynamic
     */
    private static function getRoutesConfiguration() : JsonDynamic
    {
        try {
            var content : String = sys.io.File.getContent('application/config/bundles.json');

            var libs : JsonDynamic = JsonParser.decode(content);
            var final : JsonDynamic = [];

            // Get config.json from each internal bundles
            for (i in libs['internals'].iterator()) {
                var folder : String = Std.string(libs['internals'][i]).split('.').join('/');
                var routing : String = sys.io.File.getContent('src/' + folder + '/config/routing.json');

                final.merge(replace(JsonParser.decode(routing)));
            }

            // Get config.json from each external bundles
            for (i in libs['externals'].iterator()) {
                var folder : String = Std.string(libs['externals'][i]).split('.').join('/');
                var routing : String = sys.io.File.getContent('lib/' + folder + '/config/routing.json');

                final.merge(replace(JsonParser.decode(routing)));
            }

            return final;
        } catch (ex: String) {
            throw new FileNotFoundException('No bundles configuration found (' + ex.split(':')[0] +')');
        }
    }

    /**
     * Replaces the routes options with configuration values
     * @param  routes: JsonDynamic routes's config file
     * @return           Config replaced
     */
    private static function replace(routes: JsonDynamic) : JsonDynamic
    {
        // Get parameters from routing file parameter
        var parameters: JsonDynamic = cast getParameters(routes['parameters']);

        // Loop on routes to adding them into global routes's container (if there's routes)
        if (!routes.isObject() || !routes['routes'].isObject()) {
            return null;
        }

        var arrRoutes : Array<JsonDynamic> = new Array<JsonDynamic>();
        for (route in routes['routes'].iterator()) {
            if (!routes['routes'][route].has('controller') || !routes['routes'][route].has('action')) {
                throw new NotFoundException('Route ' + route + ' does not have controller or action specified');
            }

            // Replace routing parameters
            var routingParameters : Array<String> = Std.string(route).split('/');
            var iterator: IntIterator = new IntIterator(0, routingParameters.length);
            for (i in iterator) {
                if (0 == i) {
                    if ('' != routingParameters[i]) {
                        throw new InvalidArgumentException('[' + route + '] Route must start with "/"');
                    }

                    continue;
                }

                if (routingParameters[i].charAt(0) == '%' && routingParameters[i].charAt(routingParameters[i].length - 1) == '%') {
                    var value : String = Std.string(routingParameters[i]).substr(1, Std.string(routingParameters[i]).length - 2);

                    if (parameters.has(value)) {
                        routingParameters[i] = Std.string(parameters[value]);
                    } else {
                        throw new NotFoundException('Parameter '+ value +' does not exists');
                    }
                }
            }

            var oRoute = {
                route : routingParameters.join('/'), 
                controller: Std.string(routes['routes'][route]['controller']), 
                action: Std.string(routes['routes'][route]['action'])
            };

            arrRoutes.push(cast oRoute);
        }

        var finalRoutes : JsonDynamic = cast []; 
        finalRoutes = arrRoutes;

        return finalRoutes;
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
                throw new InvalidArgumentException('Routing parameters can\'t be an array or an object');

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