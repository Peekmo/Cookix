package wx.core.http.parameters;

import wx.tools.StringMapWX;

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