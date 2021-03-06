package cookix.core.http.request;

import haxe.ds.StringMap;
import cookix.core.http.parameters.QueryParameters;
import cookix.core.http.parameters.PostParameters;
import cookix.core.http.parameters.HeaderParameters;
import cookix.core.http.parameters.RoutingParameters;

/**
 * Abstract request that every Request object have to extend
 * @author Axel Anceau (Peekmo)
 */
class AbstractRequest
{
    public var headers(default, null) : HeaderParameters;
    public var body(default, default): String;
    public var cookies(default, default) : StringMap<String>;
    public var method(default, default) : String;
    public var uri(default, default): String;
    public var query(default, null) : QueryParameters;
    public var request(default, null) : PostParameters;
    public var authorization(default, default): {user: String, pass: String};
    public var clientIp(default, null) : String;
    public var host(default, default) : String;
    public var routing(default, default) : RoutingParameters;

    /**
     * Constructor
     * @param  headers:       List<{value: String, header: String}> Request's headers
     * @param  cookies:       StringMap<String> Client's cookies
     * @param  method:        String            HTTP method of the request
     * @param  uri:           String            URI of the request
     * @param  host           String            Local server hostname
     * @param  queryString:   String            GET parameters
     * @param  postString:    String            POST parameters as x-www-form-urlencoded
     * @param  authorization: {user: String, pass: String}           User and password for Auth header
     * @param  clientIp:      String            Client's IP address
     */
    public function new(headers: List<{value: String, header: String}>, cookies: StringMap<String>, method: String,
        uri: String, host: String, queryString: String, postString: String,
        authorization: {user: String, pass: String}, clientIp: String)
    {
        this.headers = new HeaderParameters(headers);
        this.cookies = cookies;
        this.method = method;
        this.uri = this.cleanUri(uri);
        this.query = new QueryParameters(queryString);
        this.authorization = authorization;
        this.clientIp = clientIp;
        this.host = host;
        this.routing = new RoutingParameters();
        this.body = '';
        this.request = new PostParameters(postString);

        // If there's no post parameters but postString, that's the body request
        if (this.request.has(postString)) {
            this.body = postString;
            this.request = new PostParameters(''); 
        }
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

    /**
     * Checks if the Request's method is the given one
     * @param  method: String        Method to check
     * @return         Bool
     */
    public function isMethod(method: String) : Bool
    {
        return (this.method.toUpperCase() == method.toUpperCase());
    }
}