import src.core.http.request.Request;
import src.core.http.request.AbstractRequest;

class Kernel
{
    public static function main()
    {
        var request : AbstractRequest = Request.create();
    }
}