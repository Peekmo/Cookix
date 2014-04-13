package cookix.core.http.parameters;

import cookix.tools.StringMapWX;

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
        super(new StringMapWX<String>());
    }
}