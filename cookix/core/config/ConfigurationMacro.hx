package cookix.core.config;

import haxe.macro.Context;
import cookix.tools.ObjectDynamic;
import cookix.tools.JsonParser;
import cookix.exceptions.NotFoundException;
import cookix.tools.FolderReader;

/**
 * Parse and create the configuration
 * @author Axel Anceau (Peekmo)
 */
class ConfigurationMacro 
{
    /**
     * @var configuration: ObjectDynamic Full configuration
     */
    private static var configuration(null, null): ObjectDynamic;

    /**
     * @var planeConfiguration: Map<String, ObjectDynamic> Plane representation of the configuration
     */
    private static var planeConfiguration : Map<String, ObjectDynamic>;

    /**
     * INTERNAL
     * Replaces the configuration options with parameters
     * Override parameters in configuration if already exists (Except if value is "~")
     * @param  config: ObjectDynamic Config file
     * @param  params: ObjectDynamic Parameter file
     * @return         Config replaced
     */
    private static function configReplace(config: ObjectDynamic, params: ObjectDynamic, ?fullConf : ObjectDynamic) : ObjectDynamic
    {
        // To know if that's the first call of the recursive loop or not
        var origin : Bool = false;

        if (null == fullConf) {
            // Conf which will be overrided
            fullConf = configuration;
            origin   = true;
        }

        for (i in config.keys().iterator()) {
            if (config[i].isObject()) {
                if (null == fullConf[i]) {
                    fullConf[i] = cast {};
                }

                config[i] = configReplace(config[i], params, fullConf[i]);
            } else if (config[i].isArray()) {
                if (null == fullConf[i]) {
                    fullConf[i] = cast [];
                }

                config[i] = configReplace(config[i], params, fullConf[i]);
            } else if (Std.string(config[i]).charAt(0) == '%' && Std.string(config[i]).charAt(Std.string(config[i]).length - 1) == '%') {
                var value : String = Std.string(config[i]).substr(1, Std.string(config[i]).length - 2);

                if (params.has(value)) {
                    config[i]   = params[value];
                    fullConf[i] = config[i];
                } else {
                    throw new NotFoundException('Parameter '+ value +' does not exists');
                }
            } else {
                // Not overriding if value is ~
                if (Std.string(config[i]) != '~') {
                    fullConf[i] = config[i];
                } 
            }
        }

        if (!origin) {
            return config;
        }

        configuration = fullConf;
        return null;
    }

    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getConfiguration()
    {
        // To make configuration only one time
        if (configuration == null) {
            trace('Generating configuration...');
            configuration = cast {};

            var parameters : String = sys.io.File.getContent('application/config/parameters.json');
            var config     : String = sys.io.File.getContent('application/config/config.json');
            var bundles    : String = sys.io.File.getContent('application/config/bundles.json');

            var bundlesObject : ObjectDynamic = JsonParser.decode(bundles);
            var paramObject   : ObjectDynamic = JsonParser.decode(parameters);
            var confObject    : ObjectDynamic = JsonParser.decode(config);

            // Construct bundles configurations
            for (bundle in bundlesObject.iterator()) {
                var configContent : String = sys.io.File.getContent(FolderReader.getFileFromClassPath(Std.string(bundle), "/config/config.json"));

                configReplace(JsonParser.decode(configContent), paramObject);
            }

            // Finally build application's configuration
            configReplace(confObject, paramObject);


            // Register configurations in a file
            FolderReader.createFile("application/exports/config/dump_configurations.json", JsonParser.encode(configuration));

            planeConfiguration = configuration.getPlaneRepresentation();
            trace('Configuration generated');
        }

        return Context.makeExpr(configuration, Context.currentPos());
    }

    /**
     * Gets the full plane configuration
     * @return Plane configuration
     */
    macro public static function getPlaneConfiguration()
    {
        if (null == configuration) {
            getConfiguration();
        }

        // Build the object from Map (can't return the map directly :( )
        var obj : ObjectDynamic = cast {};
        for (key in planeConfiguration.keys()) {
            obj[key] = cast planeConfiguration.get(key);
        }

        return Context.makeExpr(obj, Context.currentPos());
    }


    /**
     * EXTERNAL
     * Replace the content of the given object by a configuration's parameter (if needed)
     * @param  config : ObjectDynamic Value to override
     * @return Object modified
     */
    public static function replace(config : ObjectDynamic) : ObjectDynamic
    {
        if (null == configuration) {
            getConfiguration();
        }

        if (config.isObject()) {
            for (i in config.keys().iterator()) {
                if (config[i].isArray() || config[i].isObject()) {
                    config = replace(config);
                } else if (Std.string(config[i]).charAt(0) == '%' && Std.string(config[i]).charAt(Std.string(config[i]).length - 1) == '%') {
                    var value : String = Std.string(config[i]).substr(1, Std.string(config[i]).length - 2);

                    config[i] = get(value);
                }
            }
        } else if (config.isArray()) {
            for (i in 0...config.size()) {
                if (config[i].isArray() || config[i].isObject()) {
                    config = replace(config);
                } else if (Std.string(config[i]).charAt(0) == '%' && Std.string(config[i]).charAt(Std.string(config[i]).length - 1) == '%') {
                    var value : String = Std.string(config[i]).substr(1, Std.string(config[i]).length - 2);

                    config[i] = get(value);
                }
            }
        } else if (Std.string(config).charAt(0) == '%' && Std.string(config).charAt(Std.string(config).length - 1) == '%') {
            var value : String = Std.string(config).substr(1, Std.string(config).length - 2);

            config = get(value);
        }

        return config;
    }

    /**
     * Gets value of the given attribute   
     * @param  attribute : String Attribute name
     * @throws NotFoundException 
     * @return Attribute's value
     */
    public static function get(attribute : String) : ObjectDynamic
    {
        if (null == configuration) {
            getConfiguration();
        }

        if (planeConfiguration.exists(attribute)) {
            return planeConfiguration.get(attribute);
        } else {
            throw new NotFoundException('Parameter '+ attribute +' does not exists');
        }
    }
}