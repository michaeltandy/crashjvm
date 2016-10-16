package uk.me.mjt;

public class CrashJvm {
    static {
        FindLibrary.loadLibraryExtractingFromJarIfNeeded("CrashJvm");
    }
    
    public static native void exit();
    public static native void abort();
    public static native void segfault();
    public static native boolean loadedOk();
    
    public static void main(String[] args) {
        if (loadedOk()) {
            System.out.println("Native library loaded OK!");
        }
        if (args.length >= 1) {
            switch(args[0]) {
                case "exit":
                    exit();
                    break;
                case "abort":
                    abort();
                    break;
                case "segfault":
                    segfault();
                    break;
                default:
                    System.out.println("I don't understand the argument " + args[0]);
                    System.exit(1);
            }
        }
        
    }
}
