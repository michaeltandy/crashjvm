# crashjvm
Uses JNI to trigger JVM crashes. Use it to ensure your test runners handle crashes gracefully!

The native libraries are bundled into the jar and extracted at runtime, so they should work seamlessly on the supported platforms.

[ ![Appveyor build status image](https://ci.appveyor.com/api/projects/status/7liw3mkn7hrbg7n6?svg=true) ](https://ci.appveyor.com/project/michaeltandy/crashjvm)
[ ![Travis CI build status image](https://api.travis-ci.org/michaeltandy/crashjvm.svg) ](https://travis-ci.org/michaeltandy/crashjvm)

## How to use
Import the dependency in the normal maven way
```xml
        <dependency>
            <groupId>uk.me.mjt</groupId>
            <artifactId>crashjvm</artifactId>
            <version>1.0</version>
            <scope>test</scope>
        </dependency>
```
Then in your tests you can trigger various crashes like so:
```java
import uk.me.mjt.CrashJvm;

public class ExampleClass {
    public void exampleMethod() {
        CrashJvm.loadedOk(); // Checks the native library has imported.
        CrashJvm.exit(); // Equivalent to the C stdlib method exit(66)
        CrashJvm.abort(); // Equivalent to the C stdlib method abort()
        CrashJvm.segfault(); // Causes a segmentation fault
    }
}
```

## Platforms supported
Thanks to Travis and Appveyor, native libraries are included for the following platforms:

|         | x86 64-bit        | x86 32-bit |
|---------|-------------------|------------|
| Linux   | Compiled & tested | Compiled   |
| Mac     | Compiled & tested | Compiled   |
| Windows | Compiled & tested | Compiled   |

If you know of a free CI service will allow me to compile and test on other CPU architectures, let me know and I'll integrate it.

## Almost-reproducible build
If you're looking to reproduce the build and check for nerfarious deeds on my part, feel free! The native libraries were all built on public CI platforms, and the jar includes the build numbers as well as the versions of the compilers used.

A rebuild won't be byte-for-byte identical, because of [timestamps in the windows libraries](https://stackoverflow.com/questions/1180852/deterministic-builds-under-windows) and [zip file timestamps in the jar](https://zlika.github.io/reproducible-build-maven-plugin/) but other than that I don't know of any reason the build shouldn't reproduce.
