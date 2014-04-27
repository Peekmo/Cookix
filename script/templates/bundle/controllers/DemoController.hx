package #namespace#.controllers;

import cookix.core.http.response.Response;
import cookix.core.controller.Controller;

/**
 * Controller usage example
 * @author Axel Anceau (Peekmo)
 */
@:prefix('/demo')
class DemoController extends Controller
{
    /**
     * Simple action
     */
    @:route('/hello/:name')
    public function helloAction(name: String) : Response
    {
        var response = new Response("Hello " + name);

        return response;
    }
}
