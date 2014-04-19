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
using cookix.tools.ArrayTools;
using cookix.core.routing.RoutingTools;

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
                    parseMetadata(metadata, controller);
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
     * @param  controllerClass : ClassMetadata Controller to parse
     * @param  controller      : String        Controller's name
     */
    private static function parseMetadata(controllerClass : ClassMetadata, controller : String) : Void
    {
        var prefix : String = parsePrefix(controllerClass.global);

        var myRoutes : Array<RouteType> = parseRoutes(controllerClass.methods);

        for (route in myRoutes.iterator()) {
            if (prefix != null) {
                route.elements = prefix.getElements().merge(route.elements, true);
            }

            if (route.name == null) {
                route.name = route.elements.join('_');
            }

            route.controller = controller;
        }

        routes.merge(myRoutes);
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
     * Gets routes informations from controller's methods
     * @param serviceClass : Metadata Controller's metadata
     * @param prefix       : String   Controller's routes prefix (if any)
     */
    private static function parseRoutes(serviceMethods : Map<String, Metadata>) : Array<RouteType>
    {
        var routes : Array<RouteType> = new Array<RouteType>();

        for (methodName in serviceMethods.keys()) {
            // @:Route
            var routesDeclaration : Array<MetadataType> = serviceMethods.get(methodName).getAll('Route');
            routes.merge(parseRoute(methodName, routesDeclaration));

            // Get HTTP methods allowed for routing from cookix's configuration
            var methods : Array<String> = cast configuration["cookix"]["routing"]["annotations"]["methods"];

            // Get annotations values from each of them
            for (method in methods.iterator()) {
                routesDeclaration = serviceMethods.get(methodName).getAll(method);
                routes.merge(parseRoute(methodName, routesDeclaration, method));
            }
        }

        return routes;
    }

    /**
     * Parse one method routing annotation (get, post, put, delete or route)
     * @param  methodName        : String              Method name
     * @param  routesDeclaration : Array<MetadataType> Metadata from the given method and given annotation
     * @param  method            : String              HTTP method allowed (for get, post, put, delete). Cannot be overrided
     * @return Array of all routes gets
     */
    private static function parseRoute(methodName : String, routesDeclaration : Array<MetadataType>, ?method : String) : Array<RouteType>
    {
        var routes : Array<RouteType> = new Array<RouteType>();

        for (declaration in routesDeclaration.iterator()) {
            if (declaration.params.size() == 0) {
                throw new NotFoundException("Route name not found", false);
            }

            var route : RouteType = {
                name : null,
                controller : null,
                action : methodName,
                elements : Std.string(declaration.params[0]).getElements(),
                requirements: {}
            };

            // Methods allowed
            if (method != null) {
                route.requirements.methods = [method];
            } 

            // If there's any requirements
            if (declaration.params.size() == 2) {
                var requirements : ObjectDynamic = declaration.params[1];

                if (method == null && requirements.has('methods')) {
                    route.requirements.methods = cast requirements['methods'];
                }

                // Route parameters requirements
                if (requirements.has('parameters')) {
                    route.requirements.parameters = cast requirements['parameters'];
                }

                // Route name
                if (requirements.has('name')) {
                    route.name = Std.string(requirements['name']);
                }
            }

            routes.push(route);
        }

        return routes;
    }
}