    package cookix.core.container;

/**
 * Enums to describe service's tag
 * @author Axel Anceau
 */
typedef TagType = {
    var name      : String; // Tag name (identifier)
    var type      : String; // Tag type (e.g : event)
    var method    : String; // Method to call
    var service   : String; // Service identifier of the tag
    var priority  : Int;    // Event's priority (default 0)
}