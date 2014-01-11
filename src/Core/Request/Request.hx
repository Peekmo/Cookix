package src.core.request;

/**
 * Request manager
 * @author Axel Anceau (Peekmo)
 */
class Request
{
    /**
     * Create a request for the given language
     * @return RequestInterface
     */
    public static function create() : RequestInterface
    {
        return null;
    }

    public static function test()
    {
        trace('ok');
    }
}