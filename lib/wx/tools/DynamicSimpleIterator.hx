package wx.tools;

/**
 * DynamicSimple's iterator
 * @author Axel Anceau
 */
class DynamicSimpleIterator
{
    var oDynamic : DynamicSimple;
    var keys : Array<String>;

    public function new(?oDynamic : DynamicSimple)
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