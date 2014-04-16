package cookix.tools;

/**
 * Tools to manipulate arrays
 * @author Axel Anceau (Peekmo)
 */
class ArrayTools
{
	/**
	 * Merges array2 into array1 and returns it
	 * @param array1 : Array<T> First array (reference)
	 * @param array2 : Array<T> Array that contains values to merge into array1
	 * @param copy   : Bool     Use it to use a copy of array1, otherwise, array1 will be modified
	 */
	public static function merge<T>(array1 : Array<T>, array2 : Array<T>, ?copy : Bool = false) : Array<T>
	{
		var final : Array<T> = true == copy ? Reflect.copy(array1) : array1;

		for (value in array2.iterator()) {
			final.push(value);
		}

		return final;
	}
}