package wx.exceptions;

/**
 * Exception throwed when something does not exists
 * @author Axel Anceau (Peekmo)
 */
class ServiceCompilerException extends Exception
{
    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String = 'A problem occured with service compilation', ?code: Int = 500, ?tracing: Bool = true)
    {
        super(message, code, tracing);
    }
}