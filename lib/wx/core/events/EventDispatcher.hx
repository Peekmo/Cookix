package wx.core.events;

import wx.core.container.ServiceContainer;

/**
 * Events dispatcher service. Throws events to all subscribers
 * @author Axel Anceau (Peekmo)
 */
class EventDispatcher 
{
    /**
     * @var container: ServiceContainer All services registered
     */
    var container : ServiceContainer;

    /**
     * Constructor - Inject service container to get subscribed services
     * @param  container: ServiceContainer All services
     */
    public function new(container: ServiceContainer) : Void
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
        
    }
}