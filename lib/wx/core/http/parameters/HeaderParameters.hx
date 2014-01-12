package wx.core.http.parameters;

import wx.tools.StringMapWX;

/**
 * Headers parameters bag
 * @author Axel Anceau (Peekmo)
 */
class HeaderParameters extends AbstractParametersBag
{
    public function new(params: List<{value: String, header: String}>)
    {
        var hashParams : StringMapWX<String> = new StringMapWX<String>();

        for (param in params.iterator()) {
            hashParams.set(param.header, param.value);
        }

        super(hashParams);
    }
}