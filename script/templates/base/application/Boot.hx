import cookix.core.http.request.Request;
import cookix.core.Kernel;

/**
 * Main of the application
 * @author Axel Anceau (Peekmo)
 */
class Boot
{
    /**
     * Application's entry point
     */
    public static function main()
    {
        var request = Request.create();
        Kernel.handle(request);
    }
}