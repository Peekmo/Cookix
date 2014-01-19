package wx.core.routing;

import wx.exceptions.NotFoundException;
import wx.core.context.Context;
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
     * @var context: Context Context's service
     */
    private var context(null, null): Context;

    /**
     * Constructor
     * Get all routes
     */
    public function new(context: Context)
    {
        this.routes = cast RoutingMacro.getRoutes();
        this.context = context;
    }

    /**
     * Get the route which match the given path (starting with '/')
     * @param  path: String        Path to find
     * @throws NotFoundException If no route is matching the given route
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

                    if (true == match && true == checkRequirements(oRoute)) {
                        return oRoute;
                    }
                }
            }
        }

        throw new NotFoundException('No route found for ' + path);
    }

    /**
     * Checks if the given route's requirements are followed
     * @param  oRoute: Route         Route to check
     * @return         Bool
     */
    public function checkRequirements(oRoute: Route) : Bool
    {
        // Check for method
        if (oRoute.requirements.has('_methods')) {
            var found : Bool = false;
            var methods : Array<String> = cast oRoute.requirements['_methods'];
            for (method in methods.iterator()) {
                if (this.context.request.isMethod(Std.string(method))) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                return false;
            }
        }

        return true;
    }
}