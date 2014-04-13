package cookix.core.http.response;

import php.Web;
import php.Lib;
import cookix.core.http.parameters.HeaderParameters;
import haxe.ds.StringMap;

class ResponsePhp implements ResponseInterface
{
    /**
     * Constructor
     */
    public function new() {}

    /**
     * Print the response to the client
     * @param  content: String        Content to print
     */
    public function print(?content: String) : Void
    {
        if (null != content) {
            Lib.print(content);
        }
    }

    /**
     * Set the status code to response
     * @param statusCode: Int Response's status code
     */
    public function setStatusCode(statusCode: Int) : Void
    {
        Web.setReturnCode(statusCode);
    }

    /**
     * Set response's headers
     * @param headers: HeaderParameters Headers to add
     */
    public function setHeaders(headers: HeaderParameters) : Void
    {
        for (key in headers.all().keys()) {
            Web.setHeader(key, headers.get(key));
        }
    }

    /**
     * Set client's cookies
     */
    public function setCookie(key: String, value: String, ?expire: Date, ?domain: String, ?path: String, ?secure: Bool, ?httpOnly: Bool) : Void
    {
        Web.setCookie(key, value, expire, domain, path, secure, httpOnly);
    }

    /**
     * Get client's cookies
     * @return Cookies
     */
    public function getCookies() : StringMap<String>
    {
        return Web.getCookies();
    }

    /**
     * Get client's headers
     * @return headers
     */
    public function getHeaders() : List<{ value: String, header: String }>
    {
        return Web.getClientHeaders();
    }
}