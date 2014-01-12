package wx.core.http.parameters;

import wx.tools.StringMapWX;

/**
 * Post parameter bag
 * @author Axel Anceau (Peekmo)
 */
class PostParameters extends AbstractParametersBag
{
    /**
     * Constructor
     * @param  params: String        Parameters as a string
     */
    public function new(params: String)
    {
        var arrayParams : Array<String> = params.split('&');

        var hashParams : StringMapWX<String> = new StringMapWX<String>();
        for (param in arrayParams.iterator()) {
            var aParam : Array<String> = param.split('=');
            hashParams.set(aParam[0], aParam[1]);
        }

        super(hashParams);
    }
}