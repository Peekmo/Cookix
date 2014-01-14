package wx.core.container;

import haxe.macro.Context;
import wx.tools.JsonDynamic;
import wx.tools.JsonParser;
import wx.exceptions.NotFoundException;
import wx.exceptions.FileNotFoundException;

/**
 * Parse services's files and create the service container
 * @author Axel Anceau (Peekmo)
 */
class ServiceMacro 
{
    /**
     * Builds configuration json during Compilation
     * @return Configuration
     */
    macro public static function getServices()
    {
        trace('Generating service container...');

        var internals : JsonDynamic = getInternalServices();

        trace('Service container generated');
        return Context.makeExpr(internals, Context.currentPos());
    }

    /**
     * Get internal services configuration
     * @return JsonDynamic
     */
    private static function getInternalServices() : JsonDynamic
    {
        try {
            var content : String = sys.io.File.getContent('application/config/bundles.json');

            var libs : JsonDynamic = JsonParser.decode(content);

            // Get config.json from each internal bundles
            for (i in libs['internals'].iterator()) {
                var folder : String = Std.string(libs['internals'][i]).split('.').join('/');
                var services : String = sys.io.File.getContent('src/' + folder + '/services/services.json');
            }

        } catch (ex: String) {
            throw new FileNotFoundException('No bundles configuration found (' + ex.split(':')[0] +')');
        }
        

        return null;
    }

    /**
     * Replaces the services options with configuration values
     * @param  services: JsonDynamic Services's config file
     * @return           Config replaced
     */
    private static function replace(services: JsonDynamic) : JsonDynamic
    {
        //@todo Doing the method ^_^
    }
}