package cookix.tools;

import sys.FileSystem;
import sys.io.File;
using StringTools;

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

        if (FileSystem.exists(rootFolder)) {
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
        }

        return files;
    }


    /**
     * Get all files from the given folder from the given classPath as entry point
     * @param  classPath : String Class path to start from
     * @param  folder :    String Folder's relative path
     * @return Files found
     */
    public static function getFilesFromClassPath(classPath : String, folder: String) : Array<String>
    {
        #if macro
            var path : String = haxe.macro.Context.resolvePath(classPath);
            var values : Array<String> = path.split('/');

            //Removes the last element (Class file name file name)
            values.pop();

            return getFiles(values.join('/') + folder);
        #else 
            throw "Method unsupported outside a macro";
        #end

        return null;
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
     * Get all classes in the given folder from the given class path
     * @param  classPath : String Class path to start from
     * @param  folder :    String Folder's relative path
     * @return Classes paths
     */
    public static function getClassesFromClassPath(classPath : String, folder : String) : Array<String>
    {
        var files : Array<String> = getFilesFromClassPath(classPath, folder);
        var values : Array<String> = classPath.split('/');

        //Removes the last element (Class file name file name)
        values.pop();
        var rootClassPath : String = values.join('/');

        var classPaths : Array<String> = new Array<String>();
        for (file in files) {
            if (file.endsWith(".hx")) {
                var paths : Array<String> = file.split(rootClassPath);

                if (paths.length >= 2) {
                    classPaths.push((rootClassPath + paths.pop().substr(0, -3)).split("/").join("."));
                }
            }
        }
        
        return classPaths;
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