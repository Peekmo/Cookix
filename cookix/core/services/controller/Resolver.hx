package cookix.core.services.controller;

import cookix.core.routing.Route;
import cookix.core.services.event.EventDispatcher;
import cookix.core.controller.BeforeControllerEvent;

/**
 * Controller resolver service (Managin controllers)
 * @author Axel Anceau (Peekmo)
 */
@:Service('cookix.resolver')
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
        this.dispatcher.dispatch('cookix.beforeController', new BeforeControllerEvent(inst));

        Reflect.callMethod(inst, Reflect.field(inst, 'boot'), []);
        var response = Reflect.callMethod(inst, Reflect.field(inst, route.action + 'Action'), []);

        return response;
    }
}