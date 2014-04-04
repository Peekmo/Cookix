package wx.tools;

import haxe.Json;

/**
 * JsonParser to get a dynamic json
 * @author Axel Anceau
 */
class JsonParser
{
    /**
     * Get the given string into a ObjectDynamic object
     * @param  json: String        Json to decode
     * @return       ObjectDynamic
     */
    public static function decode(json: String) : ObjectDynamic
    {
        var json : ObjectDynamic = Json.parse(json);
        return json;
    }

    /**
     * Encode the given ObjectDynamic object to a json string
     * @param  jsonDynamic: ObjectDynamic   Object to encode
     * @return              String
     */
    public static function encode(jsonDynamic: ObjectDynamic) : String 
    {
        return Json.stringify(jsonDynamic);
    }
}