package wx.core.config;

import haxe.macro.Context;
import wx.tools.ObjectDynamic;
import wx.tools.JsonParser;
import wx.exceptions.NotFoundException;

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
     * @param  config: ObjectDynamic Config file
     * @param  params: ObjectDynamic Parameter file
     * @return         Config replaced
     */
    private static function replace(config: ObjectDynamic, params: ObjectDynamic) : ObjectDynamic
    {
        for (i in config.keys().iterator()) {
            if (config[i].isArray() || config[i].isObject()) {
                config[i] = replace(config[i], params);
            } else if (Std.string(config[i]).charAt(0) == '%') {
                var value : String = Std.string(config[i]).substr(1, Std.string(config[i]).length - 2);

                if (params.has(value)) {
                    config[i] = params[value];
                } else {
                    throw new NotFoundException('Parameter '+ value +' does not exists');
                }
            }
        }

        return config;
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

            var parameters : String = sys.io.File.getContent('application/config/parameters.json');
            var config : String = sys.io.File.getContent('application/config/config.json');

            var paramObject : ObjectDynamic = JsonParser.decode(parameters);
            var confObject : ObjectDynamic = JsonParser.decode(config);

            configuration = replace(confObject, paramObject);

            trace('Configuration generated');
        }

        return Context.makeExpr(configuration, Context.currentPos());
    }
}