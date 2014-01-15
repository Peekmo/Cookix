package wx.tools;

/**
 * JsonDynamic's iterator
 * @author Axel Anceau
 */
class JsonDynamicIterator
{
    var oDynamic : JsonDynamic;
    var keys : Array<String>;

    /**
     * Constructor
     * @param  ?oDynamic :             JsonDynamic Object on which is the iteration
     */
    public function new(?oDynamic : JsonDynamic)
    {
        this.oDynamic = oDynamic;
        this.keys = oDynamic.keys();
        this.keys.reverse();
    }

    /**
     * Next iterator
     * @return Bool
     */
    public function hasNext() : Bool
    {
        return (0 != this.keys.length);
    }

    /**
     * Get the poping key
     * @return Key
     */
    public function next() : String
    {
        return this.keys.pop();
    }
}