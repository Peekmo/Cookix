package wx.core.container;

import haxe.macro.Context;
import wx.tools.ObjectDynamic;
import wx.tools.JsonParser;
import wx.exceptions.NotFoundException;
import wx.exceptions.FileNotFoundException;
import wx.core.config.ConfigurationMacro;
import sys.io.File;
import haxe.macro.Compiler;
import wx.tools.macro.MacroMetadataReader;
import wx.tools.macro.ClassMetadata;
import wx.tools.macro.Metadata;
import wx.tools.macro.MetadataType;
import wx.exceptions.ServiceCompilerException;
import wx.tools.ObjectDynamic;
import wx.exceptions.InvalidArgumentException;

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
    private static var configuration : ObjectDynamic;

    /**
     * Full application's services
     */
    private static var services : Map<String, ServiceType>;

    /**
     * All tags registered on services
     */
    private static var tags: Map<String, TagType>;

    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getServices()
    {
        if (null == services) {
            services      = new Map<String, ServiceType>();
            tags          = new Map<String, TagType>();
            configuration = ConfigurationMacro.getConfiguration();

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
        var content      : String        = File.getContent('application/config/configurations.json');
        var dependencies : ObjectDynamic = JsonParser.decode(content);


        for (dependency in dependencies.iterator()) {
            parsePackageService(Std.string(dependency));
        }
    }

    /**
     * Parses the given file system
     * @param  package: String  Entry point of the package configuration
     * @throws ServiceCompilerException
     */
    private static function parsePackageService(name : String) : Void
    {
        #if macro
            var path : String = Context.resolvePath(name);
            var values : Array<String> = path.split('/');

            //Removes the last element (Configuration file name)
            values.pop();

            var servicesContent : String = File.getContent(values.join('/') + "/config/services.json");

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
                        tag.namespace = service;
                        tags.set(tag.name, tag);
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

        return Std.string(name);
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
            parameters.push(param);
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

                var tag       = cast declaration.params[0];
                tag.method    = methodName;
                tag.namespace = "";

                serviceTags.push(tag);
            }
        }
        
        return serviceTags;
    }

    /**
     * Get given tags from services
     * @param  ?type: String        Tag's type required
     * @return        Tags
     */
    // macro public static function getTags(?type: String)
    // {
    //     if (null == tags) {
    //         getServices();
    //     }

    //     if (null == type) {
    //         return Context.makeExpr(tags, Context.currentPos());
    //     }

    //     return Context.makeExpr(tags[type], Context.currentPos());
    // }

    // /**
    //  * Get internal services configuration
    //  * @return ObjectDynamic
    //  */
    // private static function getServicesConfiguration() : ObjectDynamic
    // {
    //     try {
    //         var content : String = sys.io.File.getContent('application/config/bundles.json');

    //         var libs : ObjectDynamic = JsonParser.decode(content);
    //         var final : ObjectDynamic = {};

    //         // Get config.json from each internal bundles
    //         for (i in libs['internals'].iterator()) {
    //             var folder : String = Std.string(libs['internals'][i]).split('.').join('/');
    //             var config : String = sys.io.File.getContent('src/' + folder + '/config/config.json');
    //             var decoded : ObjectDynamic = JsonParser.decode(config);

    //             // Get parameters
    //             for (z in decoded['services'].iterator()) {
    //                 var services : String = sys.io.File.getContent('src/' + folder + '/config/' + decoded['services'][z]);
    //                 final.merge(replace(JsonParser.decode(services)));
    //             }
    //         }

    //         // Get config.json from each external bundles
    //         for (i in libs['externals'].iterator()) {
    //             var folder : String = Std.string(libs['externals'][i]).split('.').join('/');
    //             var config : String = sys.io.File.getContent('lib/' + folder + '/config/config.json');

    //             var decoded : ObjectDynamic = JsonParser.decode(config);
    //             for (z in decoded['services'].iterator()) {
    //                 var services : String = sys.io.File.getContent('lib/' + folder + '/config/' + decoded['services'][z]);
    //                 final.merge(replace(JsonParser.decode(services)));
    //             }
    //         }

    //         return final;
    //     } catch (ex: String) {
    //         throw new FileNotFoundException('No bundles configuration found (' + ex.split(':')[0] +')');
    //     }
    // }

    // *
    //  * Replaces the services options with configuration values
    //  * @param  services: ObjectDynamic Services's config file
    //  * @return           Config replaced
     
    // private static function replace(services: ObjectDynamic) : ObjectDynamic
    // {
    //     // Loop on services to dding them into global service's container (if there's services)
    //     if (!services.isObject() || !services['services'].isArray()) {
    //         return null;
    //     }

    //     var servConfiguration : ObjectDynamic = {};
    //     for (i in services['services'].iterator()) {
    //         var service = services['services'][i];

    //         if (null == service['id'] || null == service['class']) {
    //             throw new NotFoundException('A service without id has been found');
    //         }

    //         var config : ObjectDynamic = { 
    //             service: service['class'], 
    //             parameters : service['parameters']
    //         };


    //         // Replaces service's parameters
    //         for (z in config['parameters'].iterator()) {
    //             var key : String = Std.string(config['parameters'][z]);
    //             if (key.charAt(0) == '%' && key.charAt(key.length - 1) == '%') {
    //                 var value : String = Std.string(config['parameters'][z]).substr(1, Std.string(config['parameters'][z]).length - 2);

    //                 if (parameters.has(value)) {
    //                     config['parameters'][z] = parameters[value];
    //                 } else {
    //                     throw new NotFoundException('Parameter '+ value +' does not exists');
    //                 }
    //             }
    //         }

    //         if (null == config['parameters']) {
    //             config.delete('parameters');
    //         }

    //         if (service.has('tags')) {
    //             var sTags = service['tags'];
    //             config['tags'] = sTags;

    //             // Get tags
    //             for (i in sTags.iterator()) {
    //                 var key: String = Std.string(sTags[i]['type']);
    //                 var tag: String = Std.string(sTags[i]['tag']);

    //                 // Adding services informations
    //                 sTags[i]['service'] = Std.string(service['id']);

    //                 if (!tags.has(key)) {
    //                     tags[key] = cast {};
    //                 }

    //                 tags[key][tag] = sTags[i];
    //             }
    //         }

    //         servConfiguration[Std.string(service['id'])] = config;
    //     }

    //     return servConfiguration;
    // }
}