package wx.core.http.parameters;

import wx.tools.StringMapWX;

/**
 * Parameter bag
 * @author Axel Anceau (Peekmo)
 */
class AbstractParametersBag
{
    /**
     * @var params: StringMapWX<String> Parameters set
     */
    public var params(null, null) : StringMapWX<String>;

    /**
     * Constructor
     * @param  ?params: StringMapWX<String> Parameters
     */
    private function new(?params: StringMapWX<String>)
    {
        this.params = params;

        if (null == this.params) {
            this.params = new StringMapWX<String>();       
        }
    }

    /**
     * Returns all parameters
     * @return StringMapWX<String>
     */
    public function all() : StringMapWX<String>
    {
        return this.params;
    }

    /**
     * Get a value
     * @param  key:     String        Parameter's key
     * @param  ?ifNull: String        Value to return if the parameter is null
     * @return          String
     */
    public function get(key: String, ?ifNull: String) : String
    {
        if (null == this.params.get(key)) {
            return ifNull;
        }

        return this.params.get(key);
    }

    /**
     * Set a value in the parameter bag
     * @param  key:     String        Parameter's key
     * @param  value:   String        Parameter's value
     */
    public function set(key: String, value: String) : Void
    {
        this.params.set(key, value);
    }

    /**
     * Checks if a key exists or not
     * @param  key: String        Key searched
     * @return      Bool
     */
    public function has(key: String): Bool
    {
        if (null != key) {
            return this.params.exists(key);
        }

        return false;
    }
}