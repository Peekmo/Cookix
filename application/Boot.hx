// import wx.core.http.request.Request;
// import wx.core.http.request.AbstractRequest;
// import wx.templating.TemplateManager;
// import wx.core.container.ServiceContainer;
// import wx.demo.services.DemoService;
// import wx.core.routing.RoutingMacro;
// import wx.core.Kernel;

/**
 * Main of the application
 */
class Boot
{
    public static function main()
    {
        // var request = Request.create();
        // Kernel.handle(request);
        //trace(wx.config.ConfigurationMacro.getConfiguration());
        trace(wx.core.container.ServiceMacro.getServices());

        // ServiceContainer.get('demo_service').test();

        // var ctrl : wx.demo.controllers.DemoController = new wx.demo.controllers.DemoController();
        // ctrl.testAction();

        // var routes : wx.tools.JsonDynamic = RoutingMacro.getRoutes();
        // trace(routes);

        // var template : TemplateManager = new TemplateManager();
        // template.render('templates/test.tpl');
    }
}

// @:author("Nicolas")
// @debug
// class MyClass {
//     @:range(1, 8)
//     var value:Int;

//     @broken
//     @:noCompletion
//     static function method() { }
// }

// class Boot {
//     static public function main() {
//         test();
//     }

//     macro public static function test() {
//         var type = haxe.macro.Context.getType("wx.core.http.request.Request");
//         switch(type) {
//             case TInst(cl, _):
//                 trace(cl.get().statics.get());
//             case _:
//         }
//         // trace(haxe.rtti.Meta.getType(MyClass)); // { author : ["Nicolas"], debug : null }
//         // trace(haxe.rtti.Meta.getFields(MyClass).value.range); // [1,8]
//         // trace(haxe.rtti.Meta.getStatics(MyClass).method); // { broken: null }
//         return haxe.macro.Context.makeExpr({}, haxe.macro.Context.currentPos());
//     }
// }