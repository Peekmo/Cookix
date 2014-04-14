package cookix.core.routing;

import haxe.macro.Context;
import cookix.tools.ObjectDynamic;
import cookix.tools.JsonParser;
import cookix.exceptions.NotFoundException;
import cookix.exceptions.FileNotFoundException;
import cookix.core.config.ConfigurationMacro;
import sys.io.File;
import haxe.macro.Compiler;
import cookix.tools.macro.MacroMetadataReader;
import cookix.tools.macro.ClassMetadata;
import cookix.tools.macro.Metadata;
import cookix.tools.macro.MetadataType;
import cookix.exceptions.ServiceCompilerException;
import cookix.tools.ObjectDynamic;
import cookix.exceptions.InvalidArgumentException;
import cookix.tools.FolderReader;
import cookix.core.routing.RouteType;

/**
 * Macro class to load routing files
 * @author Axel Anceau (Peekmo)
 */
class RoutingMacro 
{
    /**
     * @var configuration: ObjectDynamic Application's configuration
     */
    private static var configuration : ObjectDynamic;

    /**
     * @var routes: ObjectDynamic Routes generated
     */
    private static var routes : Array<RouteType>;

    /**
     * Builds routes json during Compilation
     * @return Services
     */
    macro public static function getRoutes()
    {
        if (null == routes) {
            routes        = new Array<RouteType>();
            configuration = ConfigurationMacro.getConfiguration();

            trace('Generating routes container...');

            generateRoutes();

            trace('Routes container generated');
        }

        return Context.makeExpr(routes, Context.currentPos());
    }

    /**
     * Generates routes by parsing annotations from controllers
     */
    private static function generateRoutes() : Void
    {
        var content      : String        = File.getContent('application/config/bundles.json');
        var dependencies : ObjectDynamic = JsonParser.decode(content);


        for (dependency in dependencies.iterator()) {
            parsePackageController(Std.string(dependency));
        }
    }

    /**
     * Parse the given file system (controllers)
     * @param  name : String Entry point of the package configuration
     */
    private static function parsePackageController(name : String) : Void
    {
        #if macro
            var controllersContent : String        = File.getContent(FolderReader.getFileFromClassPath(name, "/config/routing.json"));
            var controllersDecoded : Array<String> = cast JsonParser.decode(controllersContent);

            // Parse each controllers
            for (controller in controllersDecoded.iterator()) {
                // Add the controller to the included classes
                Compiler.include(controller);

                try {
                    var metadata : ClassMetadata = MacroMetadataReader.getMetadata(controller);
                    parseMetadata(metadata);
                } catch (ex: ServiceCompilerException) {
                    throw new ServiceCompilerException(controller + ' : ' + ex.message);
                } catch (ex: NotFoundException) {
                    throw new NotFoundException(controller + ' : ' + ex.message);
                } catch (ex: InvalidArgumentException) {
                    throw new InvalidArgumentException(controller + ' : ' + ex.message);
                }
            }


        #else
            throw "You can't parse package service from outside a macro";
        #end
    }

    /**
     * Parse class metadata to build route's array
     * @param  serviceClass : ClassMetadata Controller to parse
     */
    private static function parseMetadata(serviceClass : ClassMetadata) : Void
    {
        trace(parsePrefix(serviceClass.global));
    }

    /**
     * Parse prefix's annotation (if any) to apply the prefix to all controller's routes
     * @param  serviceClass : Metadata Controller's metadata
     * @return Route's prefix
     */
    private static function parsePrefix(serviceClass : Metadata) : String
    {
        var declaration : MetadataType = null;

        try {
             declaration = serviceClass.get('Prefix'); 
        } catch (ex: NotFoundException) {
            // Null if no prefix found
            return null;
        }

        // If no value is given
        if (declaration.params.size() == 0) {
            return null;
        }

        var name : ObjectDynamic = declaration.params[0];

        // An array or an object is not a valid name for a service
        if (name.isArray() || name.isObject()) {
            throw new InvalidArgumentException("Invalid prefix for your controller, should be string", false);
        }

        var data : Array<String> = cast ConfigurationMacro.replace(Std.string(name).split('/'));
        return data.join('/');
    }

    /**
     * Get routes configuration
     * @return ObjectDynamic
     *
    private static function getRoutesConfiguration() : Void
    {
        /**try {
            var content : String = sys.io.File.getContent('application/config/bundles.json');

            var libs : ObjectDynamic = JsonParser.decode(content);
            var final : ObjectDynamic = [];

            // Get config.json from each internal bundles
            for (i in libs['internals'].iterator()) {
                var folder : String = Std.string(libs['internals'][i]).split('.').join('/');
                var config : String = sys.io.File.getContent('src/' + folder + '/config/config.json');

                var decoded : ObjectDynamic = JsonParser.decode(config);
                for (z in decoded['routing'].iterator()) {
                    var routing : String = sys.io.File.getContent('src/' + folder + '/config/' + decoded['routing'][z]);
                    final.merge(replace(JsonParser.decode(routing)));
                }
            }

            // Get config.json from each external bundles
            for (i in libs['externals'].iterator()) {
                var folder : String = Std.string(libs['externals'][i]).split('.').join('/');
                var config : String = sys.io.File.getContent('lib/' + folder + '/config/config.json');

                var decoded : ObjectDynamic = JsonParser.decode(config);
                for (z in decoded['routing'].iterator()) {
                    var routing : String = sys.io.File.getContent('lib/' + folder + '/config/' + decoded['routing'][z]);
                    final.merge(replace(JsonParser.decode(routing)));
                }
            }

            return final;
        } catch (ex: String) {
            throw new FileNotFoundException('No bundles configuration found (' + ex.split(':')[0] +')');
        }
    }

    /**
     * Replaces the routes options with configuration values
     * @param  routes: ObjectDynamic routes's config file
     * @return           Config replaced
     *
    private static function replace(routes: ObjectDynamic) : ObjectDynamic
    {
        // Get parameters from routing file parameter
        var parameters: ObjectDynamic = cast getParameters(routes['parameters']);

        // Loop on routes to adding them into global routes's container (if there's routes)
        if (!routes.isObject() || !routes['routes'].isObject()) {
            return null;
        }

        var arrRoutes : Array<ObjectDynamic> = new Array<ObjectDynamic>();
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
                action: Std.string(routes['routes'][route]['action']),
                requirements: routes['routes'][route]['requirements']
            };

            arrRoutes.push(cast oRoute);
        }

        var finalRoutes : ObjectDynamic = cast []; 
        finalRoutes = arrRoutes;

        return finalRoutes;
    }

    /**
     * Get parameters from a services's file
     * @param  parameters: ObjectDynamic   Parameters
     * @return             ObjectDynamic
     *
    private static function getParameters(parameters: ObjectDynamic) : ObjectDynamic
    {
        for (i in parameters.iterator()) {
            if (parameters[i].isArray() || parameters[i].isObject()) {
                throw new InvalidArgumentException('Routing parameters can\'t be an array or an object');

            } else if (Std.string(parameters[i]).charAt(0) == '%') {
                var value : String = Std.string(parameters[i]).substr(1, Std.string(parameters[i]).length - 2);

                var elements : Array<String> = value.split('.');

                var current : ObjectDynamic = configuration;
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
    } **/
}