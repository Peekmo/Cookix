package wx.core.http.response;

import wx.tools.JsonParser;

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
    public function new(?content: Dynamic, ?statusCode: Int): Void
    {
        super(JsonParser.encode(content), statusCode);
    }
}