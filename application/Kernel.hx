import wx.core.http.request.Request;
import wx.core.http.request.AbstractRequest;
import wx.templating.TemplateManager;
import wx.core.container.ServiceContainer;
import wx.demo.services.DemoService;

class Kernel
{
    public static function main()
    {
        ServiceContainer.initialization();
        
        var request = Request.create();
        // trace(wx.config.ConfigurationMacro.getConfiguration());
        // trace(wx.core.container.ServiceMacro.getServices());

        // ServiceContainer.get('demo_service').test();

        var ctrl : wx.demo.controllers.DemoController = new wx.demo.controllers.DemoController();
        ctrl.testAction();

        var template : TemplateManager = new TemplateManager();
        template.render('templates/test.tpl');
    }
}