package cookix.core.container;

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
    private static var configuration : haxe.ds.StringMap<ObjectDynamic>;

    /**
     * Full application's services
     */
    private static var services : Map<String, ServiceType>;

    /**
     * All tags registered on services
     */
    private static var tags: Map<String, Array<TagType>>;

    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getServices()
    {
        if (null == services) {
            services      = new Map<String, ServiceType>();
            tags          = new Map<String, Array<TagType>>();

            var dynamicConfig : ObjectDynamic = ConfigurationMacro.getConfiguration();
            configuration = dynamicConfig.getPlaneRepresentation();

            trace('Generating service container...');

            generateServices();

            trace('Service container generated');
        }

        // Build the object from Map (can't return the map directly :( )
        var obj : ObjectDynamic = cast {};
        for (key in services.keys()) {
            obj[key] = cast services.get(key);
        }

        return Context.makeExpr(obj, Context.currentPos());
    }
    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getTags()
    {
        if (null == tags) {
            getServices();
        }

        // Build the object from Map (can't return the map directly :( )
        var obj : ObjectDynamic = cast {};
        for (key in tags.keys()) {
            obj[key] = cast tags.get(key);
        }

        return Context.makeExpr(obj, Context.currentPos());
    }

    /**
     * Generate services container by parsing all annotations
     */
    private static function generateServices() : Void
    {
        var content      : String        = File.getContent('application/config/bundles.json');
        var dependencies : ObjectDynamic = JsonParser.decode(content);


        for (dependency in dependencies.iterator()) {
            parsePackageService(Std.string(dependency));
        }
    }

    /**
     * Parses the given file system
     * - Creates services and tags from its configuration files
     * - Can only be used inside a macro
     * @param  package: String  Entry point of the package configuration
     * @throws ServiceCompilerException
     */
    private static function parsePackageService(name : String) : Void
    {
        #if macro
            var servicesContent : String = File.getContent(FolderReader.getFileFromClassPath(name, "/config/services.json"));

            var servicesDecoded : Array<String> = cast JsonParser.decode(servicesContent);

            // Parse service
            for (service in servicesDecoded.iterator()) {
                Compiler.include(service);

                try {
                    var metadata : ClassMetadata = MacroMetadataReader.getMetadata(service);
                    var serviceCreated : ServiceType = parseMetadata(metadata);
                    serviceCreated.namespace = service;

                    services.set(serviceCreated.name, serviceCreated);
                    
                    // Add tags
                    for (tag in serviceCreated.tags.iterator()) {
                        tag.service = serviceCreated.name;

                        if (!tags.exists(tag.name)) {
                            tags.set(tag.name, new Array<TagType>());
                        }

                        tags.get(tag.name).push(tag);
                    }
                } catch (ex: ServiceCompilerException) {
                    throw new ServiceCompilerException(service + ' : ' + ex.message);
                } catch (ex: NotFoundException) {
                    throw new NotFoundException(service + ' : ' + ex.message);
                } catch (ex: InvalidArgumentException) {
                    throw new InvalidArgumentException(service + ' : ' + ex.message);
                }
            }
        #else
            throw "You can't parse package service from outside a macro";
        #end
    }

    /**
     * Parse class metadata to build the service container
     * @param  serviceClass : ClassMetadata Service to parse
     * @throws ServiceCompilerException
     * @return Service created
     */
    private static function parseMetadata(serviceClass : ClassMetadata) : ServiceType
    {
        var service : ServiceType = {
            name       : parseServiceName(serviceClass.global),
            parameters : parseServiceParameters(serviceClass.global),
            tags       : parseServiceTags(serviceClass.methods),
            namespace  : ""
        };

        return service;
    }

    /**
     * Get the service name from its Metadata declaration
     * @param  serviceClass : Metadata Service's metadata
     * @return Service's name
     */
    public static function parseServiceName(serviceClass : Metadata) : String
    {
        var declaration : MetadataType = null;

        try {
             declaration = serviceClass.get('Service'); 
        } catch (ex: NotFoundException) {
            throw new ServiceCompilerException('@:Service declaration not found', false);
        }

        // If no value is given
        if (declaration.params.size() == 0) {
            throw new NotFoundException("Service name not found", false);
        }

        var name : ObjectDynamic = declaration.params[0];

        // An array or an object is not a valid name for a service
        if (name.isArray() || name.isObject()) {
            throw new InvalidArgumentException("Invalid service name, should be string", false);
        }

        return Std.string(replace(name));
    }
    
    /**
     * Get the service parameters from its Metadata declaration
     * @param  serviceClass : Metadata Service's metadata
     * @return Service's parameters
     */
    public static function parseServiceParameters(serviceClass : Metadata) : Array<ObjectDynamic>
    {
        var declaration : MetadataType = null;
        var parameters : Array<ObjectDynamic> = new Array<ObjectDynamic>();

        try {
             declaration = serviceClass.get('Parameters'); 
        } catch (ex: NotFoundException) {
            // If there is not @:Parameters given, returning an empty array
            return parameters;
        }

        for (param in declaration.params.iterator()) {
            parameters.push(replace(param));
        } 

        return parameters;
    }
    
    /**
     * Get the service tags from its ClassMetadata declaration
     * @param  serviceClass : ClassMetadata Service's metadata
     * @return Service's tags
     */
    public static function parseServiceTags(serviceMethods : Map<String, Metadata>) : Array<TagType>
    {
        var serviceTags : Array<TagType> = new Array<TagType>();

        for (methodName in serviceMethods.keys()) {
            var tagsDeclaration : Array<MetadataType> = serviceMethods.get(methodName).getAll('Tag'); 

            // Check for syntax error
            for (declaration in tagsDeclaration.iterator()) {
                // If no value is given
                if (declaration.params.size() == 0) {
                    throw new NotFoundException("Tag options not found", false);
                }

                var dynamicTag = declaration.params[0];

                if (null == dynamicTag["name"] || null == dynamicTag["type"]) {
                    throw new InvalidArgumentException("Invalid tag structure", false);
                }

                var tag     = cast declaration.params[0];
                tag.method  = methodName;
                tag.service = "";

                tag.name = Std.string(replace(cast tag.name));

                serviceTags.push(tag);
            }
        }
        
        return serviceTags;
    }

    /**
     * Replace the content of the given object by a configuration's parameter (if needed)
     * @param  config : ObjectDynamic Value to override
     * @return Object modified
     */
    private static function replace(config : ObjectDynamic) : ObjectDynamic
    {
        for (i in config.keys().iterator()) {
            if (config[i].isArray() || config[i].isObject()) {
                config[i] = replace(config[i]);
            } else if (Std.string(config[i]).charAt(0) == '%' && Std.string(config[i]).charAt(Std.string(config[i]).length - 1) == '%') {
                var value : String = Std.string(config[i]).substr(1, Std.string(config[i]).length - 2);

                if (configuration.exists(value)) {
                    config = configuration.get(value);
                } else {
                    throw new NotFoundException('Parameter '+ value +' does not exists');
                }
            }
        }

        return config;
    }
}