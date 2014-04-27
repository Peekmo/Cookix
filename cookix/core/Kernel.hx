package cookix.core;

import cookix.core.routing.RouteType;
import cookix.core.container.ServiceContainer;
import cookix.core.http.request.RequestEvent;
import cookix.core.http.response.ResponseEvent;

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
        // Dispatch kernel request
        ServiceContainer.get('cookix.dispatcher').dispatch('cookix.onRequest', new RequestEvent(request));

        // Sets the request to the context
        ServiceContainer.get('cookix.context').request = request;
        var route : RouteType = cast ServiceContainer.get('cookix.routing').match(Std.string(request.uri));

        var response = ServiceContainer.get('cookix.resolver').resolve(route);

        // Dispatch kernel resposne
        ServiceContainer.get('cookix.dispatcher').dispatch('cookix.onResponse', new ResponseEvent(response));

        // Render the response
        response.render();
    }
}