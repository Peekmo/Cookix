package wx.core.routing;

import wx.exceptions.NotFoundException;

/**
 * General routing used by the router (Service)
 * @author Axel Anceau (Peekmo)
 */
@:keep class Routing
{
    /**
     * @var routes: Array<Route> All routes available
     */
    private var routes(null, null): Array<Route>;

    /**
     * Constructor
     * Get all routes
     */
    public function new()
    {
        this.routes = cast RoutingMacro.getRoutes();
    }

    /**
     * Get the route which match the given path (starting with '/')
     * @param  path: String        Path to find
     * @return       Route found
     */
    public function match(path: String) : Route
    {
        if (this.routes.length > 0) {
            for (route in this.routes.iterator()) {
                var oRoute : Route = cast route;

                var arrPath : Array<String> = path.split('/');
                var arrRoute : Array<String> = oRoute.route.split('/');

                if (arrPath.length == arrRoute.length) {
                    var iterator: IntIterator = new IntIterator(0, arrPath.length);
                    var match : Bool = true;

                    for (i in iterator) {
                        // Dynamic routing parameter
                        if (arrRoute[i].charAt(0) == ':') {
                            continue;
                        } else if (arrRoute[i] != arrPath[i] ){
                            match = false;
                            break;
                        }
                    }

                    if (true == match) {
                        return oRoute;
                    }
                }
            }
        }

        throw new NotFoundException('No route found for ' + path);
    }
}