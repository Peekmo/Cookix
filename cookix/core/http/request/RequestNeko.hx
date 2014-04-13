package cookix.core.http.request;

import neko.Web;

/**
 * Request manager for Neko language
 * @author Axel Anceau (Peekmo)
 */
class RequestNeko extends AbstractRequest
{
    /**
     * Constructor - Gets data from php.Web
     */
    public function new()
    {
        super(Web.getClientHeaders(), Web.getCookies(), Web.getMethod(), Web.getURI(), Web.getHostName(),  
            Web.getParamsString(), Web.getPostData(), Web.getAuthorization(), Web.getClientIP());
    }
}