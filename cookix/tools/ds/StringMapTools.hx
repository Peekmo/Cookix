package cookix.tools.ds;

import haxe.ds.StringMap;

/**
 * Tools to manage StringMap objects
 * @author Axel Anceau (Peekmo)
 */
class StringMapTools
{
	/**
	 * Get the number of elements in the given StringMap
	 * @param map: StringMap<T> Map to count
	 * @return Int - Total number
	 */
	public static function size<T>(map : StringMap<T>) : Int
	{
		var total : Int = 0;

		for (i in map.keys()) {
			total++;
		}

		return total;
	}
}