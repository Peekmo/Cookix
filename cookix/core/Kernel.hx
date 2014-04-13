package cookix.core;

import cookix.core.routing.Route;
import cookix.core.container.Service;
import cookix.core.http.request.RequestEvent;
import cookix.core.http.response.ResponseEvent;
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
        container.get('cookix.dispatcher').dispatch('cookix.onRequest', new RequestEvent(request));

        // Sets the request to the context
        container.get('cookix.context').request = request;
        var route : Route = cast container.get('cookix.routing').match(Std.string(request.uri));

        var response = container.get('cookix.resolver').resolve(route);

        // Dispatch kernel resposne
        container.get('cookix.dispatcher').dispatch('cookix.onResponse', new ResponseEvent(response));

        // Render the response
        response.render();
    }
}