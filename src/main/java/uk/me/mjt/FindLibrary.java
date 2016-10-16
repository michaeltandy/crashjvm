
package uk.me.mjt;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermissions;


public class FindLibrary {
    private static final FileAttribute rwx = PosixFilePermissions.asFileAttribute(PosixFilePermissions.fromString("rwx------"));
    private static final String thisFilePath = "/uk/me/mjt/FindLibrary.class";
    
    public static void loadLibraryExtractingFromJarIfNeeded(String libraryName) {
        try {
            if (isThisAJarFile()) {
                loadLibraryFromJarFile(libraryName);
            } else {
                File nativeLib = findNativeLibFile(libraryName);
                System.load(nativeLib.getAbsolutePath());
            }
            
        } catch (IOException ex) {
            throw new RuntimeException("Exception loading " + libraryName, ex);
        }
    }
    
    /**
     * In Linux, once a process has a file handle it it can read a file even if
     * it's deleted, as deleted files are kept around as long as they're open.
     * See https://unix.stackexchange.com/a/182082 for details.
     * So we can delete the extracted file as soon as we've loaded it,
     * and not worry if we miss cleanup when the JVM exits.
     */
    private static void loadLibraryFromJarFile(String libraryName) throws IOException {
        File nativeLib = extractNativeLibAsTempFile(libraryName);
        nativeLib.deleteOnExit();
        try {
            System.load(nativeLib.getAbsolutePath());
        } finally {
            nativeLib.delete();
        }
    }
    
    /**
     * Find and URL-decode the location of this class file.
     * Example outputs:
     * jar:file:/home/mtandy/Documents/asdf/crashjvm-1.0-SNAPSHOT.jar!/uk/me/mjt/FindLibrary.class
     * jar:file:/home/mtandy/Documents/asdf/crashjvm 1.0 SNAPSHOT.jar!/uk/me/mjt/FindLibrary.class
     * file:/home/mtandy/Documents/asdf/classes/uk/me/mjt/FindLibrary.class
     */
    private static String getThisClassUrl() {
        URL u = FindLibrary.class.getResource(thisFilePath);
        try { // In case there are e.g. spaces in the filename.
            return URLDecoder.decode(u.toString(), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("This line is unreachable.", e);
        }
    }
    
    private static boolean isThisAJarFile() {
        return getThisClassUrl().startsWith("jar:file:");
    }
    
    /*private static File getJarFileLocation() {
        require(isThisAJarFile());
        File f = new File(getThisClassUrl()
                .replaceFirst("!"+thisFilePath+"$", "")
                .replaceFirst("^jar:file:", ""));
        require(f.isFile());
        return f;
    }*/
    
    /**
     * One option is to extract the native library into a folder alongside 
     * the jar, and with a corresponding name.
     * That way, even if we fail to clean up the file 
     * (because our library crashes the JVM preventing graceful termination)
     * we don't end up with hundreds temp files.
     */
    /*public static File extractNativeLibAlongsideJar(String libraryName) throws IOException {
        File jarFileLocation = getJarFileLocation();
        File nativeLibFolder = new File(jarFileLocation.getParentFile(),
                jarFileLocation.getName().replaceFirst("\\.jar$", "") + "-nativelibs");
        nativeLibFolder.mkdirs();
        
        Path tempFile = Files.createTempFile(nativeLibFolder.toPath(), "nativeLibExtract", ".tmp", rwx);
        
        String libraryFilename = getPlatformSpecificLibraryFilename(libraryName);
        extractResourceTo("/"+libraryFilename, tempFile);
        
        File extractDestination = new File(nativeLibFolder, libraryFilename);
        tempFile.toFile().renameTo(extractDestination);
        return extractDestination;
    }*/
    
    private static File extractNativeLibAsTempFile(String libraryName) throws IOException {
        String libraryFilename = getPlatformSpecificLibraryFilename(libraryName);
        Path tempFile = Files.createTempFile("native", "-"+libraryFilename, rwx);
        extractResourceTo("/"+libraryFilename, tempFile);
        return tempFile.toFile();
    }
    
    private static String getPlatformSpecificLibraryFilename(String libraryName) {
        return "lib"+libraryName+".so"; // TODO
    }
    
    private static void extractResourceTo(String resource, Path destination) throws IOException {
        try (InputStream is = FindLibrary.class.getResourceAsStream(resource)) {
            Files.copy(is, destination, StandardCopyOption.REPLACE_EXISTING);
        }
    }
    
    private static File findNativeLibFile(String libraryName) {
        require(!isThisAJarFile());
        String libraryFilename = getPlatformSpecificLibraryFilename(libraryName);
        File f = new File(getThisClassUrl()
                .replaceFirst(thisFilePath+"$", "/"+libraryFilename)
                .replaceFirst("^file:", ""));
        require(f.isFile());
        return f;
    }
    
    private static void require(boolean bool) {
        if (!bool) throw new IllegalStateException("Requirement not met?");
    }
    
}
