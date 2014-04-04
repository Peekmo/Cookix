package wx.core.events;

import wx.core.container.Service;
import haxe.ds.StringMap;
import wx.tools.ObjectDynamic;

/**
 * Events dispatcher service. Throws events to all subscribers
 * @author Axel Anceau (Peekmo)
 */
@:Service('wx.dispatcher')
class EventDispatcher 
{
    /**
     * @var container: ServiceContainer All services registered
     */
    var container : Service;

    /**
     * @var events: StringMap<Subscriber> All events subsribers
     */
    var events: StringMap<Array<Subscriber>>;

    /**
     * Constructor - Inject service container to get subscribed services
     * @param  container: ServiceContainer All services
     */
    public function new(container: Service) : Void
    {
        this.container = container;

        this.events = new StringMap<Array<Subscriber>>();
        var tags : ObjectDynamic = this.container.getTags('event');
        for (i in tags.iterator()) {
            if (!this.events.exists(Std.string(i))) {
                this.events.set(Std.string(i), new Array<Subscriber>());
            }

            this.events.get(Std.string(i)).push({
                service: Std.string(tags[i]['service']), 
                method: Std.string(tags[i]['method'])
            });
        }
    }

    /**
     * Throws an event
     * @param  tag:   String        Tag of the event (to find subscribers)
     * @param  event: Dynamic       Event object
     */
    public function dispatch(tag: String, event: Dynamic) : Void
    {
        var listeners : Array<Subscriber> = this.events.get(tag);

        if (null != listeners) {
            for (listener in listeners.iterator()) {
                var args: Array<Dynamic> = new Array<Dynamic>();
                args.push(event);

                var service = this.container.get(Std.string(listener.service));

                Reflect.callMethod(service,
                    Reflect.field(service, Std.string(listener.method)), args);
            }
        }
    }
}