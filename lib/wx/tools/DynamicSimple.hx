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
    @:arrayAccess public inline function getString(key:String): DynamicSimple
    {
        return Reflect.field(this, key);
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public inline function setString(key:String, value:DynamicSimple):Void
    {
        Reflect.setField(this, key, value);
    }
     
    /**
     * Get a value
     * @param  key Key of the map
     * @return     Field
     */
    @:arrayAccess public inline function getInt(?key:Int = 0): Dynamic
    {
        var iarr : Array<Dynamic> = cast this;
        return iarr[key];
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public inline function setInt(key:Int, value:Dynamic):Void
    {
        var iarr : Array<Dynamic> = cast this;
        iarr[key] = value;
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

    public inline function clear()
    {
        for (i in keys()) {
            delete(i);
        }
    }
    
    /**
     * Returns all keys
     * @return Array<String>
     */
    public inline function keys():Array<String>
    {
        return Reflect.fields(this);
    }

    public inline function arrayValues(): Array<Dynamic>
    {
        var iarr : Array<Dynamic> = cast this;
        return iarr;
    }

    /**
     * Check if the given key is an object or not
     * @param  key: String        Key to check
     * @return      Bool
     */
    public inline function isObject(key: String): Bool
    {
        return (!(Reflect.field(this, key).length > 0) && !isArray(key));
    }

    /**
     * Check if the given key is an array or not
     * @param  key: String        Key to check
     * @return      Bool
     */
    public inline function isArray(key: String): Bool
    {
        return Reflect.hasField(Reflect.field(this, key), '__a');
    }

    /**
     * Returns iterator through the object
     * @return Iterator
     */
    public inline function iterator() : DynamicSimpleIterator
    {   
        var simpleIterator : DynamicSimpleIterator = new DynamicSimpleIterator(this);

        if (has('__a')) {
            // Register var before to reaffect
            var before : DynamicSimple = this;

            var iarr : Array<Dynamic> = cast this;
            var it : IntIterator = new IntIterator(0, iarr.length);

            for (i in it) {
                setString(Std.string(i), iarr[i]);
            }

            simpleIterator = new DynamicSimpleIterator(this);
            this = before;
        } 
      
        return simpleIterator;
    }
}