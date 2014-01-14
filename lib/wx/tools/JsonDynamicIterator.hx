package wx.tools;

/**
 * JsonDynamic's iterator
 * @author Axel Anceau
 */
class JsonDynamicIterator
{
    var oDynamic : JsonDynamic;
    var keys : Array<String>;

    public function new(?oDynamic : JsonDynamic)
    {
        this.oDynamic = oDynamic;
        this.keys = oDynamic.keys();
        this.keys.reverse();
    }

    public function hasNext()
    {
        return (0 != this.keys.length);
    }

    public function next() : String
    {
        return this.keys.pop();
    }
}