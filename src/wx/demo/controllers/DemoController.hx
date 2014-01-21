package wx.demo.controllers;

import wx.core.http.response.Response;
import wx.core.http.response.JsonResponse;

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

        return new JsonResponse({test: 'ok'});
    }
}