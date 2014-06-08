package cookix.core.services.controller;

import cookix.core.routing.RouteType;
import cookix.core.services.event.EventDispatcher;
import cookix.core.controller.BeforeControllerEvent;
import cookix.core.services.context.Context;

/**
 * Controller resolver service (Managin controllers)
 * @author Axel Anceau (Peekmo)
 */
@:Service('cookix.resolver')
@:Parameters('@cookix.dispatcher', '@cookix.context')
class Resolver
{
    /**
     * @var dispatcher: Dispatcher Event dispatcher
     */
    public var dispatcher: EventDispatcher;

    /**
     * @var context : Context Request's context service
     */
    public var context : Context;

    /**
     * Contructor
     * @param context   : Context Request's context service
     * @param dispatcher: Dispatcher Event dispatcher
     */
    public function new(dispatcher: EventDispatcher, context: Context)
    {
        this.context    = context;
        this.dispatcher = dispatcher;
    }

    /**
     * Call the given Controller's route
     * @param  route: Route         Route to the action
     * @return        Response
     */
    public function resolve(route: RouteType) : Dynamic
    {
        // Creates the controller, call the boot method (from superclass) and action
        var inst : Dynamic = Type.createEmptyInstance(Type.resolveClass(route.controller));

        // Before controller event
        this.dispatcher.dispatch('cookix.beforeController', new BeforeControllerEvent(inst));

        var response = Reflect.callMethod(inst, Reflect.field(inst, route.action), this.context.request.routing.values());

        return response;
    }
}