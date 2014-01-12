import wx.core.http.request.Request;
import wx.core.http.request.AbstractRequest;
import wx.templating.TemplateManager;

class Kernel
{
    public static function main()
    {
        var request : AbstractRequest = Request.create();
        var template : TemplateManager = new TemplateManager();
        template.render('templates/test.tpl');
    }
}