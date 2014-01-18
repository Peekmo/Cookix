package wx.core.routing;

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
    }

    public function toString() : String
    {
        return '{
            "route": ' + this.route + ',
            "controller": ' + this.controller + ',
            "action": ' + this.action + '
        }';
    }
}