package cookix.core.http.parameters;

import haxe.ds.StringMap;

/**
 * Headers parameters bag
 * @author Axel Anceau (Peekmo)
 */
class HeaderParameters extends AbstractParametersBag
{
    public function new(params: List<{value: String, header: String}>)
    {
        var hashParams : StringMap<String> = new StringMap<String>();

        if (null != params) {
            for (param in params.iterator()) {
                hashParams.set(param.header, param.value);
            }
        }
        
        super(hashParams);
    }
}