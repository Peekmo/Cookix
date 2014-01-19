package wx.core.routing;

import wx.exceptions.NotFoundException;

/**
 * General routing used by the router (Service)
 * @author Axel Anceau (Peekmo)
 */
class Routing
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

                if (oRoute.route == path) {
                    return oRoute;
                }
            }
        }

        throw new NotFoundException('No route found for ' + path);
    }
}