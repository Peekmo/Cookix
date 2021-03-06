package cookix.core.services.routing;

import cookix.exceptions.NotFoundException;
import cookix.core.services.context.Context;
import cookix.core.http.parameters.RoutingParameters;
import cookix.core.routing.RouteType;
import cookix.core.routing.RoutingMacro;
import cookix.tools.ObjectDynamic;
using cookix.core.routing.RoutingTools;

/**
 * General routing used by the router (Service)
 * @author Axel Anceau (Peekmo)
 */
@:Service("cookix.routing")
@:Parameters("@cookix.context")
class Routing
{
    /**
     * @var routes: Array<Route> All routes available
     */
    private var routes(null, null): Array<RouteType>;

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
    public function match(path: String) : RouteType
    {
        if (this.routes.length > 0) {
            for (route in this.routes.iterator()) {
                var oRoute : RouteType = cast route;

                var arrPath : Array<String> = path.getElements();
                var arrRoute : Array<String> = oRoute.elements;
                var routingParameters : RoutingParameters = new RoutingParameters();

                if (arrPath.length == arrRoute.length) {
                    var iterator: IntIterator = new IntIterator(0, arrPath.length);
                    var match : Bool = true;

                    for (i in iterator) {
                        // Dynamic routing parameter
                        if (arrRoute[i].charAt(0) == ':') {
                            var rParam : String = arrRoute[i].substring(1, arrRoute[i].length);
                            if (oRoute.requirements.parameters != null) {
                                var parameters : ObjectDynamic = cast oRoute.requirements.parameters;

                                if (parameters.has(rParam)) {
                                    var reg : EReg = new EReg(Std.string(parameters[rParam]), '');

                                    if (!reg.match(arrPath[i])) {
                                        match = false;
                                        break;
                                    }
                                }
                            }

                            routingParameters.set(rParam, arrPath[i]);
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
     * @param  oRoute: RouteType Route to check
     * @return         Bool
     */
    public function checkRequirements(oRoute: RouteType) : Bool
    {
        // Check for method
        if (oRoute.requirements.methods != null) {
            var found : Bool = false;
            var methods : Array<String> = cast oRoute.requirements.methods;
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