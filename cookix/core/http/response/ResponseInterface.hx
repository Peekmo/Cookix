package cookix.core.http.response;

import cookix.core.http.parameters.HeaderParameters;
import haxe.ds.StringMap;

interface ResponseInterface
{
    /**
     * Print the response to the client
     * @param  content: String        Content to print
     */
    public function print(?content: String) : Void;

    /**
     * Set the status code to response
     * @param statusCode: Int Response's status code
     */
    public function setStatusCode(statusCode: Int) : Void;

    /**
     * Set response's headers
     * @param headers: HeaderParameters Headers to add
     */
    public function setHeaders(headers: HeaderParameters) : Void;

    /**
     * Set client's cookies
     */
    public function setCookie(key: String, value: String, ?expire: Date, ?domain: String, ?path: String, ?secure: Bool, ?httpOnly: Bool) : Void;

    /**
     * Get client's cookies
     * @return Cookies
     */
    public function getCookies() : StringMap<String>;

    /**
     * Get client's headers
     * @return headers
     */
    public function getHeaders() : List<{ value: String, header: String }>;
}