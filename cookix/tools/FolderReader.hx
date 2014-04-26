package cookix.tools;

import sys.FileSystem;
import sys.io.File;

/**
 * Utility to deal with folders
 * @author Axel Anceau (Peekmo)
 */
class FolderReader 
{
    /**
     * Returns an array of all files which are in the given folder and its subfolders
     * @param rootFolder : String Root folder for the search
     * @return Files found
     */
    public static function getFiles(rootFolder: String) : Array<String>
    {
        var files : Array<String> = new Array<String>();
        var folders : Array<String> = FileSystem.readDirectory(rootFolder);

        for (file in folders.iterator()) {
            var path : String = rootFolder + '/' + file;
            if (FileSystem.isDirectory(path)) {
                var data : Array<String> = getFiles(path);

                for (i in data) {
                    files.push(i);
                }

            } else {
                files.push(path);
            }
        }

        return files;
    }

    /**
     * Get a file path relative to a class path
     * @param  classPath : String Class path to start from
     * @return Complete file path
     */
    public static function getFileFromClassPath(classPath : String, relativePath: String) : String
    {
        #if macro
            var path : String = haxe.macro.Context.resolvePath(classPath);
            var values : Array<String> = path.split('/');

            //Removes the last element (Class file name file name)
            values.pop();

            return values.join('/') + relativePath;
        #else 
            throw "Method unsupported outside a macro";
        #end

        return null;
    }

    /**
     * Creates a file to the given path, with the given content
     * (Creates all directories if they not exists)
     * @param  path     : String Path to the file (each folders separated by '/')
     * @param  ?content : String File's content
     */
    public static function createFile(path : String, ?content : String) : Void
    {
        var parts : Array<String> = path.split('/');
        var fileName : String = parts.pop();

        // Create all directories necessaries
        createDirectory(parts.join('/'));

        if (content == null) {
            content = "";
        }

        File.saveContent(path, content);
    }

    /**
     * Creates the given directory (and all path's directories if needed)
     * @param  path : String Path to the given directory
     */
    public static function createDirectory(path : String) : Void
    {
        var parts : Array<String> = path.split('/');
        
        var done : String = null;

        for (part in parts.iterator()) {
            done = done == null ? part : done + "/" + part;

            if (!FileSystem.exists(done)) {
                FileSystem.createDirectory(done);
            }
        }
    }
}