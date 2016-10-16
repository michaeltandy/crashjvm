#!/bin/bash
set -e

if [ -z "$MAVEN_PROJECTBASEDIR" ]; then
  echo "MAVEN_PROJECTBASEDIR must be set, but it isn't." >&2
  exit 1
fi

#env
mkdir -p $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64
mkdir -p $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/x86

UNAME_STR=$(uname);

if [[ "$UNAME_STR" == "Linux" ]]; then
  gcc -shared -fPIC -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64/libCrashJvm.so" -I $JAVA_HOME/include -I $JAVA_HOME/include/linux "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc --version > $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/linux-compiler-version.txt

elif [[ "$UNAME_STR" == "Darwin" ]]; then
  gcc -arch x86_64 -dynamiclib -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64/libCrashJvm.jnilib" -I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers -I/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers/ "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc -arch i386 -dynamiclib -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/x86/libCrashJvm.jnilib" -I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers -I/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers/ "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc --version > $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/osx-compiler-version.txt

elif [[ "$UNAME_STR" == "MSYS_NT-6.3" ]]; then
  ls $JAVA_HOME
  ls $JAVA_HOME/include

  gcc -shared -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64/CrashJvm.dll" -I $JAVA_HOME/include -I $JAVA_HOME/include/linux "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"

else
  echo "Didn't recognise $UNAME_STR" >&2
  exit 1
fi

# os mac os x
# arch x86_64
# compile for i386 with -arch i386
