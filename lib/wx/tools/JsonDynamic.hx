package wx.tools;

import wx.exceptions.ExistsException;


/**
 * JsonDynamic class to use structured objects
 * Cast the value to JsonDynamic if that's not an Int, String, Bool or Float
 * @author Axel Anceau
 */
abstract JsonDynamic(Dynamic) from Dynamic
{
    /**
     * Get a value
     * @param  key Key of the map
     * @return     Field
     */
    @:arrayAccess public inline function getString(key:String): JsonDynamic
    {
        var value;

        if (!has(key) && Std.parseInt(key) != null) {
            value = getInt(Std.parseInt(key));
        } else {
            value = Reflect.field(this, key);
        }

        return value;
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public inline function setString(key:String, value:JsonDynamic):Void
    {
        if (!has(key) && Std.parseInt(key) != null) {
            setInt(Std.parseInt(key), value);
        } else {
            Reflect.setField(this, key, value);
        }
    }
          
    /**
     * Sets a string value for the given key
     * @param  key:   String Key to set
     * @param  value: String Value to set
     */
    @:arrayAccess public inline function setStringString(key:String, value:String):Void
    {
        var v : JsonDynamic = cast value;

        if (!has(key) && Std.parseInt(key) != null) {
            setInt(Std.parseInt(key), v);
        } else {
            Reflect.setField(this, key, v);
        }
    }
          
    /**
     * Sets an int value for the given key
     * @param  key:   String Key to set
     * @param  value: Int    Value to set
     */
    @:arrayAccess public inline function setStringInt(key:String, value:Int):Void
    {
        var v : JsonDynamic = cast value;

        if (!has(key) && Std.parseInt(key) != null) {
            setInt(Std.parseInt(key), v);
        } else {
            Reflect.setField(this, key, v);
        }
    }
          
    /**
     * Sets a bool value for the given key
     * @param  key:   String Key to set
     * @param  value: Bool   Value to set
     */
    @:arrayAccess public inline function setStringBool(key:String, value:Bool):Void
    {
        var v : JsonDynamic = cast value;

        if (!has(key) && Std.parseInt(key) != null) {
            setInt(Std.parseInt(key), v);
        } else {
            Reflect.setField(this, key, v);
        }
    }
          
    /**
     * Sets a float value for the given key
     * @param  key:   String Key to set
     * @param  value: Float   Value to set
     */
    @:arrayAccess public inline function setStringFloat(key:String, value:Float):Void
    {
        var v : JsonDynamic = cast value;

        if (!has(key) && Std.parseInt(key) != null) {
            setInt(Std.parseInt(key), v);
        } else {
            Reflect.setField(this, key, v);
        }
    }
     
    /**
     * Get a value
     * @param  key Key of the map
     * @return     Field
     */
    @:arrayAccess public inline function getInt(?key:Int = 0): JsonDynamic
    {
        var iarr : Array<JsonDynamic> = cast this;
        return iarr[key];
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public inline function setInt(key:Int, value:JsonDynamic):Void
    {
        var iarr : Array<JsonDynamic> = cast this;
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
    
    /**
     * Returns all keys
     * @return Array<String>
     */
    public inline function keys():Array<String>
    {
        return Reflect.fields(this);
    }

    /**
     * Check if the given key is an object or not
     * @param  key: String        Key to check
     * @return      Bool
     */
    public inline function isObject(): Bool
    {
        return ((Reflect.fields(this).length > 0) && !(Reflect.fields(this)[0] == '__s') && !isArray());
    }

    /**
     * Check if the given key is an array or not
     * @param  key: String        Key to check
     * @return      Bool
     */
    public inline function isArray(): Bool
    {
        return ((Reflect.fields(this).length == 2) && (Reflect.fields(this)[0] == '__a'));
    }

    /**
     * Merge the current map with the given one
     * @throws wx.exceptions.ExistsException On same key
     * @param  map: StringMapWX<T> StringMapWX to merge
     */
    public function merge(map: JsonDynamic)
    {
        if (null == map) {
            return;
        }
        
        for (key in map.keys()) {
            if (has(key)) {
                throw new ExistsException('Can\'t merge this arrays. ['+ key +'] key is in common');
            }

            setString(key, map[key]);
        }
    }

    /**
     * Returns iterator through the object
     * @return Iterator
     */
    public inline function iterator() : JsonDynamicIterator
    {   
        var simpleIterator : JsonDynamicIterator = new JsonDynamicIterator(this);

        if (has('__a') || (has('length') && has('copy'))) {
            var iarr : Array<JsonDynamic> = cast this;
            var it : IntIterator = new IntIterator(0, iarr.length);
            var fake : JsonDynamic = cast {};

            for (i in it) {
                Reflect.setField(fake, Std.string(i), iarr[i]);
            }

            simpleIterator = new JsonDynamicIterator(fake);
        } 
      
        return simpleIterator;
    }
}