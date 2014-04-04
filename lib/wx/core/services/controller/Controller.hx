package wx.core.controller;

import wx.core.container.Service;

/**
 * Controller to extends to get all tools
 * @author Axel Anceau (Peekmo)
 */
@:Service('wx.resolver')
class Controller
{
    /**
     * @var container: ServiceContainer Contains all services (instanciated or not)
     */
    public var container(default, default) : Service;

    /**
     * Boots the Controller class
     */
    public function boot()
    {
        this.container = new Service();
    }
}