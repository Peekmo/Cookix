package wx.tools;

import wx.exceptions.ExistsException;
import haxe.ds.StringMap;

/**
 * ObjectDynamic class to use structured objects
 * Cast the value to ObjectDynamic if that's not an Int, String, Bool or Float
 * @author Axel Anceau
 */
abstract ObjectDynamic(Dynamic) from Dynamic
{
    /**
     * Get a value
     * @param  key Key of the map
     * @return     Field
     */
    @:arrayAccess public function getString(key:String): ObjectDynamic
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
    @:arrayAccess public function setString(key:String, value:ObjectDynamic):Void
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
    @:arrayAccess public function setStringString(key:String, value:String):Void
    {
        var v : ObjectDynamic = cast value;

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
    @:arrayAccess public function setStringInt(key:String, value:Int):Void
    {
        var v : ObjectDynamic = cast value;

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
    @:arrayAccess public function setStringBool(key:String, value:Bool):Void
    {
        var v : ObjectDynamic = cast value;

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
    @:arrayAccess public function setStringFloat(key:String, value:Float):Void
    {
        var v : ObjectDynamic = cast value;

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
    @:arrayAccess public function getInt(?key:Int = 0): ObjectDynamic
    {
        var iarr : Array<ObjectDynamic> = cast this;
        return iarr[key];
    }
     
    /**
     * Sets a value for the given key
     * @param  key:   String Key to set
     * @param  value: V      Value to set
     */
    @:arrayAccess public function setInt(key:Int, value:ObjectDynamic):Void
    {
        var iarr : Array<ObjectDynamic> = cast this;

        if (key >= iarr.length) {
            iarr.push(value);
        } else {
            iarr[key] = value;
        }
    }

    /**
     * Push a value in the object (numerical index)
     * @param  value: ObjectDynamic Value to push
     */
    public function push(value: ObjectDynamic) : Void
    {
        var iarr : Array<ObjectDynamic> = cast this;
        iarr.push(value);
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
     * Return all values
     * @return Array<ObjectDynamic>
     */
    public function values(): Array<ObjectDynamic>
    {
        var values : Array<ObjectDynamic> = new Array<ObjectDynamic>();

        for (key in keys().iterator()) {
            values.push(Reflect.field(this, key));
        }

        return values;
    }

    /**
     * Returns number of elements in the current object
     * @return Int
     */
    public function size() : Int
    {
        if (isArray() || isObject()) {
            var obj : Array<ObjectDynamic> = cast this;
            return obj.length;
        } else {
            return 0;
        }
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
        return ((Reflect.fields(this)[0] == '__a') || (has('length') && has('copy')));
    }

    /**
     * Merge the current map with the given one (set force to true if you want to erase an existing value)
     * @throws wx.exceptions.ExistsException On same key
     * @param  map: StringMapWX<T> StringMapWX to merge
     */
    public function merge(map: ObjectDynamic, ?force: Bool = false) : Void
    {
        if (null == map) {
            return;
        }

        if (map.isArray()) {
            var value : Int = size();
            var bonus : Int = 0;

            for (val in map.iterator()) {
                setInt(value + bonus, val);
                bonus++;
            }
        } else {
            for (key in map.keys()) {
                if (has(key) && false == force) {
                    throw new ExistsException('Can\'t merge this arrays. ['+ key +'] key is in common');
                }

                setString(key, map[key]);
            }
        }
    }

    /**
     * Returns iterator through the object
     * @return Iterator
     */
    public function iterator() : ObjectDynamicIterator
    {   
        var simpleIterator : ObjectDynamicIterator = new ObjectDynamicIterator(this);

        if (has('__a') || (has('length') && has('copy'))) {
            var iarr : Array<ObjectDynamic> = cast this;
            var it : IntIterator = new IntIterator(0, iarr.length);
            var fake : ObjectDynamic = cast {};

            for (i in it) {
                Reflect.setField(fake, Std.string(i), iarr[i]);
            }

            simpleIterator = new ObjectDynamicIterator(fake);
        } 
      
        return simpleIterator;
    }


    /**
     * Get the plane representation of the current object
     * eg: { x : { a : b } }
     * => x.a => b
     * @return Map<String, ObjectDynamic>
     */
    public function getPlaneRepresentation() : Map<String, ObjectDynamic>
    {
        var map : StringMap<ObjectDynamic> = new StringMap<ObjectDynamic>();
        getRepresentation(map);

        return map;
    }

    private function getRepresentation(map : StringMap<ObjectDynamic>, ?obj : ObjectDynamic, ?key : String) : Void
    {
        if (null == key) {
            obj = this;
            key = "";
        }

        for (k in obj.keys().iterator()) {
            var currKey = "" == key ? k : key + "." + k; 
            map.set(currKey, obj[k]);        

            if (obj[k].isArray() || obj[k].isObject()) {
                getRepresentation(map, obj[k], currKey);
            }
        }
    }
}