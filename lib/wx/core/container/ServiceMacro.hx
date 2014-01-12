package wx.core.container;

import haxe.macro.Context;
import haxe.Json;
import wx.tools.DynamicSimple;
import wx.exceptions.NotFoundException;

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

        var content : String = sys.io.File.getContent('application/config/libs.json');
        var libs : DynamicSimple = Json.parse(content);

        var iarr : Array<Dynamic> = cast libs['internals'];
        trace(iarr[0]);

        trace('Service container generated');
        return Context.makeExpr(libs, Context.currentPos());
    }
}