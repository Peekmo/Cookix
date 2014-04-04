package wx.core.routing;

import haxe.ds.StringMap;
import wx.tools.ObjectDynamic;

/**
 * Route data structure
 * @author Axel Anceau (Peekmo)
 */
class Route 
{
    /**
     * @var route: String Route name
     */
    public var route(default, default): String;

    /**
     * @var controller: String Controller of the route
     */
    public var controller(default, default): String;

    /**
     * @var action: String Action to execute on the controller
     */
    public var action(default, default): String;

    /**
     * @var requirements: ObjectDynamic Requirements on route / request
     */
    public var requirements(default, null): ObjectDynamic;

    /**
     * @var routing: StringMap<String> Routing parameters 
     */
    public var routing(default, default): StringMap<String>;

    /**
     * Constructor
     * @param  route:      String        Route name
     * @param  controller: String        Controller of the route
     * @param  action:     String        Action to execute on the controller
     */
    public function new(route: String, controller: String, action: String, ?requirements: ObjectDynamic)
    {
        this.route = route;
        this.controller = controller;
        this.action = action;
        this.routing = new StringMap<String>();
        this.requirements = requirements;

        if (null == requirements) {
            this.requirements = cast {};
        }
    }
}