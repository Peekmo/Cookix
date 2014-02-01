package wx.core.http.request;

/**
 * Request event sent on KernelRequest
 */
class RequestEvent 
{
    /**
     * @var request: Dynamic Request instance
     */
    public var request(default, default) : Dynamic;

    /**
     * Constructor
     * @param  request: Dynamic       Request get from the user
     */
    public function new(request: Dynamic)
    {
        this.request = request;
    }
}