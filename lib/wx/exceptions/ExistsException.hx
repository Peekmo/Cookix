package wx.exceptions;

/**
 * Exception throwed when something does not exists
 * @author Axel Anceau (Peekmo)
 */
class ExistsException extends Exception
{
    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String = 'Already exists', ?code: Int = 409)
    {
        super(message, code);
    }
}