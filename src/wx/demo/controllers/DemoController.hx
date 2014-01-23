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

        var response = new JsonResponse({test: 'ok',test2: 'ok',test3: 'ok',test4: 'ok',test5: 'ok',});
        response.setCookie('test', 'value');

        return response;
    }
}