package src.core.http.parameters;

import src.tools.StringMapWX;

/**
 * Parameter bag
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