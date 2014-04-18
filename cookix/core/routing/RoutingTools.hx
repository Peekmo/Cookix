package cookix.core.routing;

/**
 * Tools to manipulate some routes (as string or route)
 * @author Axel Anceau (Peekmo)
 */
class RoutingTools
{
	/**
	 * Get routes elements from the given route's string
	 * Removes empty values from the begining of the route
	 * @param  route : String Route
	 * @return  An array of all elements
	 */
	public static function getElements(route : String) : Array<String>
	{
		var elements : Array<String> = route.split('/');
		elements.shift();

		return elements;
	}
}