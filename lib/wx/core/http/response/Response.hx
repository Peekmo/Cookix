package wx.core.http.response;

import wx.core.http.parameters.HeaderParameters;
import haxe.ds.StringMap;

/**
 * Response to send to the client
 * @author Axel Anceau (Peekmo)
 */
class Response
{
    /**
     * @var headers: HeaderParameters Parameters of the response
     */
    public var headers(default, default) : HeaderParameters;

    /**
     * @var statusCode: Int HTTP status code to send to the client
     */
    public var statusCode(default, default) : Int;

    /**
     * @var content: String Content to print
     */
    public var content(default, default): String;

    /**
     * @var response: Dynamic Response object (depend on compilation target)
     * Could be ResponsePhp or ResponseNeko
     */
    public var response(null, null): ResponseInterface;

    /**
     * Constructor
     * @param  ?content    : String Content to print
     * @param  ?statusCode : Int    HTTP status code of the reponse
     */
    public function new(?content : String, ?statusCode : Int, ?headers: StringMap<String>)
    {
        #if php
            this.response = new ResponsePhp();
        #elseif neko
            this.response = new ResponseNeko();
        #end

        this.content = content;
        this.statusCode = statusCode;
        this.headers = new HeaderParameters(this.response.getHeaders());

        if (null != headers) {
            for (i in headers.keys()) {
                this.headers.set(i, headers.get(i));
            }
        }
    }

    /**
     * Print the content of the response to the client
     */
    public function render() : Void
    {
        if (null == this.statusCode) {
            this.statusCode = if (null == this.content) 204 else 200;
        }

        this.response.setStatusCode(this.statusCode);
        this.response.setHeaders(this.headers);
        this.response.print(this.content);
    }

    /**
     * Set client's cookies
     */
    public function setCookie(key: String, value: String, ?expire: Date, ?domain: String, ?path: String, ?secure: Bool, ?httpOnly: Bool) : Void
    {
        this.response.setCookie(key, value, expire, domain, path, secure, httpOnly);
    }

    /**
     * Get client's cookies
     * @return Cookies
     */
    public function getCookies() : StringMap<String>
    {
        return this.response.getCookies();
    }
}