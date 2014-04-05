package wx.core.config;

import haxe.macro.Context;
import wx.tools.ObjectDynamic;
import wx.tools.JsonParser;
import wx.exceptions.NotFoundException;
import wx.tools.FolderReader;

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
     * Replaces the configuration options with parameters
     * Override parameters in configuration if already exists (Except if value is "~")
     * @param  config: ObjectDynamic Config file
     * @param  params: ObjectDynamic Parameter file
     * @return         Config replaced
     */
    private static function replace(config: ObjectDynamic, params: ObjectDynamic, ?fullConf : ObjectDynamic) : ObjectDynamic
    {
        // To know if that's the first call of the recursive loop or not
        var origin : Bool = false;

        if (null == fullConf) {
            // Conf which will be overrided
            fullConf = configuration;
            origin   = true;
        }

        for (i in config.keys().iterator()) {
            if (config[i].isArray() || config[i].isObject()) {
                if (null == fullConf[i]) {
                    fullConf[i] = cast {};
                }

                config[i] = replace(config[i], params, fullConf[i]);
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

                replace(JsonParser.decode(configContent), paramObject);
            }

            // Finally build application's configuration
            replace(confObject, paramObject);
            trace('Configuration generated');
        }

        return Context.makeExpr(configuration, Context.currentPos());
    }
}