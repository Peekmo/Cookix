package wx.core.http.response;

import wx.tools.JsonParser;
import haxe.ds.StringMap;
/**
 * Response which returns a json encoding response
 * @author Axel Anceau (Peekmo)
 */
class JsonResponse extends Response
{
    /**
     * Constructor
     * @param  ?content    : Dynamic Content to print
     * @param  ?statusCode : Int    HTTP status code of the reponse
     */
    public function new(?content: Dynamic, ?statusCode: Int, ?headers: StringMap<String>): Void
    {
        if (null == headers) {
            headers = new StringMap<String>();
        }

        headers.set('Content-Type', 'application/json');
        super(JsonParser.encode(content), statusCode, headers);
    }
}