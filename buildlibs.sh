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

if [[ "$RELEASEBUILD" == "true" ]]; then
  echo "Performing release build, using native libraries collected from CI runners."
  cp -r $MAVEN_PROJECTBASEDIR/nativelibs/* $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/

elif [[ "$UNAME_STR" == "Linux" ]]; then
  gcc -shared -m64 -fPIC -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64/libCrashJvm.so" -I $JAVA_HOME/include -I $JAVA_HOME/include/linux "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  # If the line below fails, run sudo apt-get -y install libc6-dev-i386
  gcc -shared -m32 -fPIC -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/x86/libCrashJvm.so" -I $JAVA_HOME/include -I $JAVA_HOME/include/linux "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc --version > $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/linux-native-info.txt
  echo "Travis job $TRAVIS_JOB_ID" >> $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/linux-native-info.txt

elif [[ "$UNAME_STR" == "Darwin" ]]; then
  gcc -arch x86_64 -dynamiclib -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64/libCrashJvm.jnilib" -I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers -I/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers/ "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc -arch i386 -dynamiclib -o "$MAVEN_PROJECTBASEDIR/target/classes/nativelibs/x86/libCrashJvm.jnilib" -I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers -I/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers/ "$MAVEN_PROJECTBASEDIR/src/main/java/uk/me/mjt/CrashJvm.c"
  gcc --version > $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/osx-native-info.txt
  echo "Travis job $TRAVIS_JOB_ID" >> $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/osx-native-info.txt

elif [[ "$UNAME_STR" == "MSYS_NT-6.3" ]]; then
  echo "Hopefully this is running on appveyor, and the libraries have already been built!"
  cp $MAVEN_PROJECTBASEDIR/x86/CrashJvm.dll $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/x86
  cp $MAVEN_PROJECTBASEDIR/amd64/CrashJvm.dll $MAVEN_PROJECTBASEDIR/target/classes/nativelibs/amd64

else
  echo "Didn't recognise $UNAME_STR" >&2
  exit 1
fi

# os mac os x
# arch x86_64
# compile for i386 with -arch i386
