package src.core.http.request;

import haxe.ds.StringMap;
import src.core.http.parameters.QueryParameters;
import src.core.http.parameters.PostParameters;
import src.core.http.parameters.HeaderParameters;

/**
 * Abstract.http.requestthat every Request object have to extend
 * @author Axel Anceau (Peekmo)
 */
class AbstractRequest
{
    public var headerParameters(null, null) : HeaderParameters;
    public var body(default, default): String;
    public var cookies(default, default) : StringMap<String>;
    public var method(default, default) : String;
    public var uri(default, default): String;
    public var queryParams(null, null) : QueryParameters;
    public var postParams(null, null) : PostParameters;
    public var authorization(default, default): {user: String, pass: String};
    public var clientIp(default, null) : String;

    /**
     * Constructor
     * @param  headers:       List<{value: String, header: String}> Request's headers
     * @param  cookies:       StringMap<String> Client's cookies
     * @param  method:        String            HTTP method of the request
     * @param  uri:           String            URI of the request
     * @param  queryString:   String            GET parameters
     * @param  postString:    String            POST parameters as x-www-form-urlencoded
     * @param  authorization: {user: String, pass: String}           User and password for Auth header
     * @param  clientIp:      String            Client's IP address
     */
    public function new(headers: List<{value: String, header: String}>, cookies: StringMap<String>, method: String,
        uri: String, queryString: String, postString: String, authorization: {user: String, pass: String}, clientIp: String)
    {
        this.headerParameters = new HeaderParameters(headers);
        this.cookies = cookies;
        this.method = method;
        this.uri = uri;
        this.queryParams = new QueryParameters(queryString);
        this.authorization = authorization;
        this.clientIp = clientIp;

        this.body = '';
        this.postParams = new PostParameters(postString);

        // If there's no post parameters but postString, that's the body request
        if (this.request().has(postString)) {
            this.body = postString;
            this.postParams = new PostParameters(''); 
        }
    }

    /**
     * Returns all request's headers
     * @return HeaderParameters
     */
    public function headers() : HeaderParameters
    {
        return this.headerParameters;
    }

    /**
     * Gets query parameters
     * @return    QueryParameters
     */
    public function query() : QueryParameters
    {
        return this.queryParams;
    }

    /**
     * Gets a POST parameter
     * @return      PostParameters
     */
    public function request() : PostParameters
    {
        return this.postParams;
    }

    /**
     * Returns a clean URI (without files) - It removes all dots.  
     * @param  uri: String        Base URI
     * @return      String
     */
    public function cleanUri(uri: String) : String
    {
        var array : Array<String> = uri.split('/');
        var iterator : IntIterator = new IntIterator(0, array.length);

        for (i in iterator) {
            if (Lambda.has(array[i].split(''), '.')) {
                var cut : Array<String> = array.slice(i+1);
                uri = '/' + cleanUri(cut.join('/'));
                break;
            }
        }

        return uri;
    }
}