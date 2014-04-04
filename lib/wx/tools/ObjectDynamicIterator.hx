package wx.tools;

/**
 * ObjectDynamic's iterator
 * @author Axel Anceau
 */
class ObjectDynamicIterator
{
    var oDynamic : ObjectDynamic;
    var values : Array<ObjectDynamic>;

    /**
     * Constructor
     * @param  ?oDynamic :             ObjectDynamic Object on which is the iteration
     */
    public function new(?oDynamic : ObjectDynamic)
    {
        this.oDynamic = oDynamic;
        this.values = oDynamic.values();
        this.values.reverse();
    }

    /**
     * Next iterator
     * @return Bool
     */
    public function hasNext() : Bool
    {
        return (0 != this.values.length);
    }

    /**
     * Get the poping key
     * @return Key
     */
    public function next() : ObjectDynamic
    {
        return this.values.pop();
    }
}