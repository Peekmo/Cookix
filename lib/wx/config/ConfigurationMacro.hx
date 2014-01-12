package wx.config;

import haxe.macro.Context;
import haxe.Json;
import wx.tools.DynamicSimple;
import wx.exceptions.NotFoundException;

/**
 * Parse and create the configuration
 * @author Axel Anceau (Peekmo)
 */
class ConfigurationMacro 
{
    /**
     * Replaces the configuration options with parameters
     * @param  config: DynamicSimple Config file
     * @param  params: DynamicSimple Parameter file
     * @return         Config replaced
     */
    private static function replace(config: DynamicSimple, params: DynamicSimple) : DynamicSimple
    {
        for (name in config.keys()) {
            var field = config[name];

            if (config.isArray(name)) {
                config[name] = replace(field, params);

            } else if (Std.string(config[name]).charAt(0) == '%') {
                var value : String = Std.string(config[name]).substr(1, Std.string(config[name]).length - 2);

                if (params.has(value)) {
                    config.set(name, params[value]);
                } else {
                    throw new NotFoundException('Parameter '+ value +' does not exists');
                }
            }
        }

        return config;
    }

    /**
     * Builds configuration json during Compilation
     * @return Configuration's json
     */
    macro public static function getConfiguration()
    {
        trace('Generating configuration...');

        var parameters : String = sys.io.File.getContent('application/config/parameters.json');
        var config : String = sys.io.File.getContent('application/config/config.json');

        var paramObject : DynamicSimple = Json.parse(parameters);
        var confObject : DynamicSimple = Json.parse(config);

        var final = replace(confObject, paramObject);

        trace('Configuration generated');
        return Context.makeExpr(final, Context.currentPos());
    }
}