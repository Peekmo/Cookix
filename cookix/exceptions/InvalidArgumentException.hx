package cookix.exceptions;

/**
 * Exception throwed when an argument is invalid
 * @author Axel Anceau (Peekmo)
 */
class InvalidArgumentException extends Exception
{
    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String = 'Invalid argument exception', ?code: Int = 412, ?tracing: Bool = true)
    {
        super(message, code, tracing);
    }
}