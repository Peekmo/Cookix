package cookix.core.services.event;

import cookix.core.container.Service;
import haxe.ds.StringMap;
import cookix.tools.ObjectDynamic;
import cookix.core.container.TagType;

/**
 * Events dispatcher service. Throws events to all subscribers
 * @author Axel Anceau (Peekmo)
 */
@:Service('cookix.dispatcher')
class EventDispatcher 
{
    /**
     * @var container: ServiceContainer All services registered
     */
    var container : Service;

    /**
     * Constructor - Inject service container to get subscribed services
     * @param  container: ServiceContainer All services
     */
    public function new(container: Service) : Void
    {
        this.container = container;
    }

    /**
     * Throws an event
     * @param  tag:   String        Tag of the event (to find subscribers)
     * @param  event: Dynamic       Event object
     */
    public function dispatch(tag: String, event: Dynamic) : Void
    {
        var listeners : Array<TagType> = this.container.getTags(tag, 'event');

        for (listener in listeners.iterator()) {
            var args: Array<Dynamic> = new Array<Dynamic>();
            args.push(event);

            var service = this.container.get(Std.string(listener.service));

            // Call the method
            Reflect.callMethod(service,
                Reflect.field(service, Std.string(listener.method)), args);
        }
    }
}