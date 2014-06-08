package cookix.core.controller;

import cookix.core.container.ServiceContainer;
import cookix.core.services.container.Service;

/**
 * Controller to extends to get all tools
 * @author Axel Anceau (Peekmo)
 */
class Controller
{
    /**
     * @var container: ServiceContainer Contains all services (instanciated or not)
     */
    public var container(default, default) : Service;

    /**
     * Boots the Controller class
     */
    public function __init__()
    {
        this.container = ServiceContainer.get('cookix.container');
    }
}