package wx.tools;

/**
 * DynamicSimple class to use structured objects
 * @author Axel Anceau
 */
abstract DynamicSimple(Dynamic) from Dynamic
{
    /**
     * Get a value
     * @param  key Key of the map
     * @return     Field
     */
    @:arrayAccess public inline function get(key:String): DynamicSimple
    {
        return Reflect.field(this, key);
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public inline function set(key:String, value:DynamicSimple):Void
    {
        Reflect.setField(this, key, value);
    }
     
    /**
     * Checks if there's the given key
     * @param  key Key to search
     * @return     Bool
     */
    public inline function has(key:String):Bool
    {
        return Reflect.hasField(this, key);
    }
     
    /**
     * Deletes a given key from the map
     * @param  key Key to delete
     * @return     Bool
     */
    public inline function delete(key:String):Bool
    {
        return Reflect.deleteField(this, key);
    }
    
    /**
     * Returns all keys
     * @return Array<String>
     */
    public inline function keys():Array<String>
    {
        return Reflect.fields(this);
    }

    /**
     * Check if the given key is an array or not
     * @param  key: String        Key to check
     * @return      Bool
     */
    public inline function isArray(key: String): Bool
    {
        return !(Reflect.field(this, key).length > 0);
    }
}