import wx.core.http.request.Request;
import wx.core.http.request.AbstractRequest;
import wx.templating.TemplateManager;
import wx.core.container.ServiceContainer;
import wx.demo.services.DemoService;
import wx.core.routing.RoutingMacro;
import wx.core.Kernel;

/**
 * Main of the application
 */
class Boot
{
    public static function main()
    {
        var request = Request.create();
        Kernel.handle(request);
        // trace(wx.config.ConfigurationMacro.getConfiguration());
        // trace(wx.core.container.ServiceMacro.getServices());

        // ServiceContainer.get('demo_service').test();

        // var ctrl : wx.demo.controllers.DemoController = new wx.demo.controllers.DemoController();
        // ctrl.testAction();

        // var routes : wx.tools.JsonDynamic = RoutingMacro.getRoutes();
        // trace(routes);

        var template : TemplateManager = new TemplateManager();
        template.render('templates/test.tpl');
    }
}