package cookix.tools.macro;

import haxe.macro.Type.ClassField;
import haxe.macro.Expr;
import cookix.tools.macro.Metadata;

/**
 * All metadata informations from the given class
 * @author Axel Anceau (Peekmo)
 */
class ClassMetadata
{
    /**
     * Class itself metadata
     */
    public var global     : Metadata;

    /**
     * Metadata on class's attributes
     */
    public var attributes : Map<String, Metadata>;

    /**
     * Metadata on class's methods
     */
    public var methods    : Map<String, Metadata>;

    /**
     * Constructor - Builds the different fields
     * @param  globals : Array<MetadataEntry> Class's itself metadata
     * @param  fields  : Array<ClassField>    Attributes and methods from the class
     */
    public function new(globals : Array<MetadataEntry>, fields : Array<ClassField>)
    {
        this.global     = new Metadata(globals);
        this.attributes = new Map<String, Metadata>();
        this.methods    = new Map<String, Metadata>();

        this.parseFields(fields);
    }

    /**
     * Parse fields to fill attributes & methods map
     * @param  fields : Array<ClassField>
     */
    public function parseFields(fields : Array<ClassField>) : Void
    {
        for (field in fields.iterator()) {
            switch (field.kind) {
                case FVar(read, write):
                    this.attributes.set(field.name, new Metadata(field.meta.get()));
                case FMethod(k):
                    this.methods.set(field.name, new Metadata(field.meta.get()));
            }
        }
    }
}