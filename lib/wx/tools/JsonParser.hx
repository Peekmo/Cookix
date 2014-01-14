package wx.tools;

import haxe.Json;

/**
 * JsonParser to get a dynamic json
 * @author Axel Anceau
 */
class JsonParser
{
    /**
     * Get the given string into a JsonDynamic object
     * @param  json: String        Json to decode
     * @return       JsonDynamic
     */
    public static function decode(json: String) : JsonDynamic
    {
        var json : JsonDynamic = Json.parse(json);
        return json;
    }

    /**
     * Encode the given JsonDynamic object to a json string
     * @param  jsonDynamic: JsonDynamic   Object to encode
     * @return              String
     */
    public static function encode(jsonDynamic: JsonDynamic) : String 
    {
        return Json.stringify(jsonDynamic);
    }
}