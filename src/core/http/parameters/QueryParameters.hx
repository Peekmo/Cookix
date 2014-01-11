package src.core.http.parameters;

import src.tools.StringMapWX;

/**
 * Query parameter bag
 * @author Axel Anceau (Peekmo)
 */
class QueryParameters extends AbstractParametersBag
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