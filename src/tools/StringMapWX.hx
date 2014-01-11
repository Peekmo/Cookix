package src.tools;

import haxe.ds.StringMap;
/**
 * StringMap extended for WX
 * @author Axel Anceau (Peekmo)
 */
class StringMapWX<T> extends StringMap<T>
{
    /**
     * Returns the size of the StringMap
     * @return Int
     */
    public function size() : Int
    {
        var i : Int = 0;

        for (object in this.iterator()) {
            i++;
        }

        return i;
    }
}