package wx.core.services.routing;

import wx.exceptions.NotFoundException;
import wx.core.services.context.Context;
import wx.core.http.parameters.RoutingParameters;
import wx.core.routing.Route;
import wx.core.routing.RoutingMacro;

/**
 * General routing used by the router (Service)
 * @author Axel Anceau (Peekmo)
 */
@:Service("wx.routing")
@:Parameters("@wx.context")
class Routing
{
    /**
     * @var routes: Array<Route> All routes available
     */
    private var routes(null, null): Array<Route>;

    /**
     * @var context: Context Context's service
     */
    private var context(default, null): Context;

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
                var routingParameters : RoutingParameters = new RoutingParameters();

                if (arrPath.length == arrRoute.length) {
                    var iterator: IntIterator = new IntIterator(0, arrPath.length);
                    var match : Bool = true;

                    for (i in iterator) {
                        // Dynamic routing parameter
                        if (arrRoute[i].charAt(0) == ':') {
                            var rParam : String = arrRoute[i].substring(1, arrRoute[i].length);
                            if (oRoute.requirements.has(rParam)) {
                                var reg : EReg = new EReg(Std.string(oRoute.requirements[rParam]), '');

                                if (!reg.match(arrPath[i])) {
                                    match = false;
                                    break;
                                }

                                routingParameters.set(rParam, arrPath[i]);
                            }

                        } else if (arrRoute[i] != arrPath[i] ){
                            match = false;
                            break;
                        }
                    }

                    if (true == match && true == checkRequirements(oRoute)) {
                        this.context.request.routing = routingParameters;
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