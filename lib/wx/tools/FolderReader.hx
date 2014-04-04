package wx.tools;

import sys.FileSystem;

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
}