package cookix.exceptions;

/**
 * Exception throwed when a file is not found
 * @author Axel Anceau (Peekmo)
 */
class FileNotFoundException extends Exception
{
    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String = 'File not found', ?code: Int = 404, ?tracing: Bool = true)
    {
        super(message, code, tracing);
    }
}