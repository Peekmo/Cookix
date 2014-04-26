package cookix.core.http.parameters;

import haxe.ds.StringMap;

/**
 * Routing parameter bag
 * @author Axel Anceau (Peekmo)
 */
class RoutingParameters extends AbstractParametersBag
{
    /**
     * Constructor
     * @param  params: String        Parameters as a string
     */
    public function new()
    {
        super(new StringMap<String>());
    }
}