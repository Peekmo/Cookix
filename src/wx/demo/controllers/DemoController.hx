package wx.demo.controllers;

import wx.core.http.response.Response;

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
        this.container.get('demo_service').test();

        return new Response('test');
    }
}