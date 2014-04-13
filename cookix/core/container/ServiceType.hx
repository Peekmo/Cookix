package cookix.core.container;

import cookix.tools.ObjectDynamic;

/**
 * Typedef to describe service's data
 * @author Axel Anceau
 */
typedef ServiceType = {
    var name       : String;
    var parameters : Array<ObjectDynamic>;
    var tags       : Array<TagType>;
    var namespace  : String;
}