package wx.core.controller;

/**
 * Event sent just before calling controller method
 * @author Axel Anceau (Peekmo)
 */
class BeforeControllerEvent 
{
    /**
     * @var controller: Dynamic Controller which is called
     */
    public var controller(default, default) : Dynamic;

    /**
     * Constructor
     * @param  controller: Dynamic       Controller which is called
     */
    public function new(controller: Dynamic) 
    {
        this.controller = controller;
    }
}