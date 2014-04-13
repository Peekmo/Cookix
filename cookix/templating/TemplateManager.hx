package cookix.templating;

import sys.io.File;
// import php.Web;
// import php.Lib;

/**
 * Abstract request that every Request object have to extend
 * @author Axel Anceau (Peekmo)
 */
class TemplateManager
{
    public function new()
    {

    }

    public function render(view: String) : Void
    {
        // var resource : String = File.getContent(Web.getCwd() + view);
        // var template : haxe.Template = new haxe.Template(resource);
        // Lib.print(template.execute({name: 'Axel', age: 21}));
    }
}