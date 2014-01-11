package src.core.http.request;

import php.Web;

/**
 * Request manager for PHP language
 * @author Axel Anceau (Peekmo)
 */
class RequestPhp extends AbstractRequest
{
    /**
     * Constructor - Gets data from php.Web
     */
    public function new()
    {
        super(Web.getClientHeaders(), Web.getCookies(), Web.getMethod(), Web.getURI(), 
            Web.getParamsString(), Web.getPostData(), Web.getAuthorization(), Web.getClientIP());
    }
}