package wx.core;

import wx.core.routing.Route;
import wx.core.container.Service;
import wx.core.http.request.RequestEvent;
import wx.core.http.response.ResponseEvent;
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
    public static function handle(request: Dynamic)
    {
        // Get service container
        var container : Service = new Service();

        // Dispatch kernel request
        container.get('wx.dispatcher').dispatch('wx.onRequest', new RequestEvent(request));

        // Sets the request to the context
        container.get('wx.context').request = request;
        var route : Route = cast container.get('wx.routing').match(Std.string(request.uri));

        var response = container.get('wx.resolver').resolve(route);

        // Dispatch kernel resposne
        container.get('wx.dispatcher').dispatch('wx.onResponse', new ResponseEvent(response));

        // Render the response
        response.render();
    }
}