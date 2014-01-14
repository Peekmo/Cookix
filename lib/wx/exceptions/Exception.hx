package wx.exceptions;

/**
 * Generique Exception
 * @author Axel Anceau (Peekmo)
 */
class Exception
{
    public var message(default, null): String;
    public var code(default, null): Int;

    /**
     * Constructor
     * @param  ?message: String        Exception's message
     * @param  ?code:    Int           Error code
     */
    public function new(?message: String, ?code: Int)
    {
        this.message = message;
        this.code = code;

        trace('Exception [ '+ this.code +' ]' + ' : ' + this.message);
    }
}