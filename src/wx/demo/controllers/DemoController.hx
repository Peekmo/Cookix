package wx.demo.controllers;

/**
 * Controller usage example
 * @author Axel Anceau (Peekmo)
 */
class DemoController extends wx.core.controller.Controller
{
    /**
     * Simple action
     */
    public function testAction()
    {
        this.ok();
        this.container.get('demo_service').test();
    }
}