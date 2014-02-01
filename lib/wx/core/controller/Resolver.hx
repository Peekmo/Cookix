package wx.core.controller;

import wx.core.routing.Route;
import wx.core.events.EventDispatcher;

/**
 * Controller resolver service (Managin controllers)
 * @author Axel Anceau (Peekmo)
 */
class Resolver
{
    /**
     * @var dispatcher: Dispatcher Event dispatcher
     */
    public var dispatcher: EventDispatcher;

    /**
     * Contructor
     * @param dispatcher: Dispatcher Event dispatcher
     */
    public function new(dispatcher: EventDispatcher)
    {
        this.dispatcher = dispatcher;
    }

    /**
     * Call the given Controller's route
     * @param  route: Route         Route to the action
     * @return        Response
     */
    public function resolve(route: Route) : Dynamic
    {
        // Creates the controller, call the boot method (from superclass) and action
        var inst : Dynamic = Type.createEmptyInstance(Type.resolveClass(route.controller));

        // Before controller event
        this.dispatcher.dispatch('wx.beforeController', new BeforeControllerEvent(inst));

        Reflect.callMethod(inst, Reflect.field(inst, 'boot'), []);
        var response = Reflect.callMethod(inst, Reflect.field(inst, route.action + 'Action'), []);

        return response;
    }
}