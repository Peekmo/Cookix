import wx.core.http.request.Request;
import wx.core.http.request.AbstractRequest;
import wx.templating.TemplateManager;
import wx.core.container.ServiceContainer;
import wx.demo.services.DemoService;

class Kernel
{
    public static function main()
    {
        var request = Request.create();
        // trace(wx.config.ConfigurationMacro.getConfiguration());
        // trace(wx.core.container.ServiceMacro.getServices());

        ServiceContainer.initialization();
        ServiceContainer.get('demo_service').test();
        var template : TemplateManager = new TemplateManager();
        template.render('templates/test.tpl');
    }
}