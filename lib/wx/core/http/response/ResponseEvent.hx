package wx.core.http.response;

/**
 * Response event
 * @author Axel Anceau (Peekmo)
 */
class ResponseEvent 
{
    /**
     * @var response: Dynamic Response instance
     */
    public var response(default, default) : Response;

    /**
     * Constructor
     * @param  response: Dynamic       Response sent to the user
     */
    public function new(response: Dynamic)
    {
        this.response = response;
    }
}