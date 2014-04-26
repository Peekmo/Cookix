package cookix.core.http.parameters;

import haxe.ds.StringMap;

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
        var hashParams : StringMap<String> = new StringMap<String>();

        if (null != params) {
            var arrayParams : Array<String> = params.split('&');

            for (param in arrayParams.iterator()) {
                var aParam : Array<String> = param.split('=');
                hashParams.set(aParam[0], aParam[1]);
            }
        }

        super(hashParams);
    }
}