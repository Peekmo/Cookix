package cookix.tools.macro;

import cookix.tools.ObjectDynamic;
import haxe.macro.Expr;
import cookix.exceptions.NotFoundException;
import haxe.macro.Type.ClassField;
using StringTools;

/**
 * Utils to easily deal with macro's metadata
 * @author Axel Anceau (Peekmo)
 */
class Metadata
{
    /**
     * Object's metadata lists
     */
    public var metadata : Array<MetadataType>;

    /**
     * Constructor
     * Builds the metadata array
     * @param  metadata : Array<MetadataEntry> MetadataEntry gets from class or fields
     */
    public function new(metadata : Array<MetadataEntry>)
    {
        this.metadata = new Array<MetadataType>();
        for (meta in metadata.iterator()) {
            this.metadata.push(this.parse(meta));
        }
    }

    /**
     * Parse MetadataEntries to build MetadataType's array 
     * @param  metadata : MetadataEntry MetadataEntry parsed
     * @return MetadataType created
     */
    private function parse(metadata : MetadataEntry) : MetadataType
    {
        var meta = {name : "", params : cast {}};

        if (metadata.name.startsWith(':')) {
            metadata.name = metadata.name.substr(1);
        }

        meta.name   = metadata.name.toLowerCase();
        meta.params = this.parseParams(metadata.params);

        return meta;
    }

    /**
     * Parse params from MetadataEntry (Array of Expr) - Recursive
     * @param  params : Array<Expr> Expr from metadata
     * @return ObjectDynamic (simplified object)
     */
    private function parseParams(params : Array<Expr>) : ObjectDynamic
    {
        var oDynamic : ObjectDynamic = cast [];

        for (param in params.iterator()) {
            // http://api.haxe.org/haxe/macro/ExprDef.html
            switch (param.expr) {
                // Value
                case EConst(c) :
                    switch (c) {
                        case CInt(v)    : oDynamic.push(cast v);
                        case CString(s) : oDynamic.push(cast s);
                        case CFloat(f)  : oDynamic.push(cast f);
                        case CIdent(s)  : oDynamic.push(cast s);
                        case _          : throw "Constant not supported";
                    };

                // Object declaration
                case EObjectDecl(fields) :
                    var obj : ObjectDynamic = cast {};

                    // Iterate through all object's fields
                    for (field in fields.iterator()) {
                        var args = new Array<Expr>();
                        args.push(field.expr);

                        // Gets only the first value in case of object
                        obj[field.field] = this.parseParams(args)[0];
                    }

                    oDynamic.push(obj);

                // Array
                case EArrayDecl(values) :
                    oDynamic.push(this.parseParams(values));

                case _ : 
                    throw "This type of annotation cannot be parsed";
            }
        }

        return oDynamic;
    }

    /**
     * Checks if the given metadata is existing or not
     * /!\ Case insensitive
     * @param  name : String Metadata's name
     * @return      Bool
     */
    public function has(name : String) : Bool
    {
        name = name.toLowerCase();
        for (meta in this.metadata) {
            if (meta.name == name) {
                return true;
            }
        }

        return false;
    }

    /**
     * Get the given Metadata type, by its name
     * /!\ Case insensitive
     * @param  name: String        Metadata's name
     * @throws NotFoundException
     * @return       MetadataType
     */
    public function get(name: String) : MetadataType
    {
        name = name.toLowerCase();
        for (meta in this.metadata) {
            if (meta.name == name) {
                return meta;
            }
        }

        throw new NotFoundException("There is no Metadata identified by " + name, false);
    }

    /**
     * Get the given Metadata type, by its name
     * /!\ Case insensitive
     * @param  name: String Metadata's name
     * @return  Array<MetadataType>
     */
    public function getAll(name: String) : Array<MetadataType>
    {
        name = name.toLowerCase();
        var metas : Array<MetadataType> = new Array<MetadataType>();

        for (meta in this.metadata.iterator()) {
            if (meta.name == name) {
                metas.push(meta);
            }
        }

        return metas;
    }
}