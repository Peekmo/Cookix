package wx.core.routing;

import haxe.ds.StringMap;

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
     * @var routing: StringMap<String> Routing parameters 
     */
    public var routing(default, default): StringMap<String>;

    /**
     * Constructor
     * @param  route:      String        Route name
     * @param  controller: String        Controller of the route
     * @param  action:     String        Action to execute on the controller
     */
    public function new(route: String, controller: String, action: String)
    {
        this.route = route;
        this.controller = controller;
        this.action = action;
        this.routing = new StringMap<String>();
    }
}