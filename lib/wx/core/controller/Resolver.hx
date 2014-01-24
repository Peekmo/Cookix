package wx.core.controller;

import wx.core.routing.Route;

/**
 * Controller resolver service (Managin controllers)
 * @author Axel Anceau (Peekmo)
 */
@:keep class Resolver
{
    /**
     * Contructor
     */
    public function new() {}

    /**
     * Call the given Controller's route
     * @param  route: Route         Route to the action
     * @return        Response
     */
    public function resolve(route: Route) : Dynamic
    {
        // Creates the controller, call the boot method (from superclass) and action
        var inst : Dynamic = Type.createEmptyInstance(Type.resolveClass(route.controller));
        Reflect.callMethod(inst, Reflect.field(inst, 'boot'), []);
        var response = Reflect.callMethod(inst, Reflect.field(inst, route.action + 'Action'), []);

        return response;
    }
}