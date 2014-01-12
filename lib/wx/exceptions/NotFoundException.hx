package wx.exceptions;

/**
 * Exception throwed when something does not exists
 * @author Axel Anceau (Peekmo)
 */
class NotFoundException extends Exception
{
    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String, ?code: Int)
    {
        if (null == message) {
            message = 'Not found';
        }

        if (null == code) {
            code = 404;
        }

        super(message, code);
    }
}