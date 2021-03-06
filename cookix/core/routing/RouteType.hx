package cookix.core.routing;

/**
 * Describe the data structure of a route
 * @author Axel Anceau (Peekmo)
 */
typedef RouteType = {
    var name                    : String;            // Name of the route
    var elements                : Array<String>;     // Elements from the route (between each "/")
    var controller              : String;            // Path to the controller
    var action                  : String;            // Method name
    @:optional var requirements : RouteRequirements; // Route requirements (e.g : methods)
}

typedef RouteRequirements = {
	@:optional var methods    : Array<String>;       // Methods allowed on the route (POST, GET, ...)
	@:optional var parameters : Map<String, String>; // Requirements on routing parameters (key, regexp)
}