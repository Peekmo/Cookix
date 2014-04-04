package wx.tools.macro;

/**
 * Tool to read metadata from a macro
 * @author Axel Anceau (Peekmo)
 */
class MacroMetadataReader
{
    /**
     * Get class metadata by its package
     * @param  name : String Class full path
     * @return      Class's metadata
     */
    public static function getMetadata(name : String) : ClassMetadata
    {
        #if macro
            var type = haxe.macro.Context.getType(name);
            switch(type) {
                case TInst(cl, _):
                    return new ClassMetadata(cl.get().meta.get(), cl.get().fields.get());
                case _:
                    throw "Can\'t get metadata from this type of object";
            }
        #else
            throw "Can't get Metadata with MMR at runtime";
        #end

        return null;
    }
}