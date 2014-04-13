package cookix.tools;

import haxe.ds.StringMap;
import cookix.exceptions.ExistsException;

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

    /**
     * Merge the current map with the given one
     * @throws cookix.exceptions.ExistsException On same key
     * @param  map: StringMapWX<T> StringMapWX to merge
     */
    public function merge(map: StringMapWX<T>)
    {
        if (null == map) {
            return;
        }
        
        for (key in map.keys()) {
            if (this.exists(key)) {
                throw new ExistsException('Can\'t merge this arrays. ['+ key +'] key is in common');
            }

            this.set(key, map.get(key));
        }
    }
}