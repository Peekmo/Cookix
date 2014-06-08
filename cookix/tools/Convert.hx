package cookix.tools;

/**
 * Tool to convert some types to other ones
 * @author Axel Anceau (Peekmo)
 */
class Convert
{
	/**
	 * Convert the given value into boolean
	 * - Any string except "false" will returns true
	 * - Any ints except 0 will returns true
	 * - Empty array will returns false
	 * - Objects will returns true
	 * @param  value: Dynamic Value to convert
	 * @return Boolean value
	 */
	public static inline function bool(value: Dynamic) : Bool
	{
		var s : String = Std.string(value);
		return (s != 'false' && s != '0' && s != '[]');
	}
}