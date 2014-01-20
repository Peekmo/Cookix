package wx.core;

import wx.core.routing.Route;
import wx.core.container.Service;
import Imports;

/**
 * Application's kernel, called on every request just after booting
 */
class Kernel 
{
    /**
     * Called on the begining of the request
     * @param  request: AbstractRequest Request received
     */
    public static function handle(request)
    {
        // Get service container
        var container : Service = new Service();

        // Sets the request to the context
        container.get('context').request = request;
        var route : Route = cast container.get('routing').match(Std.string(request.uri));

        var controller = new wx.core.controller.Resolver();
        var response = controller.resolve(route);

        response.render();
    }
}