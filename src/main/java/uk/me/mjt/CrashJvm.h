#ifndef CrashJvm_H
#define CrashJvm_H

#include <jni.h>

JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_exit(JNIEnv *, jobject);
JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_abort(JNIEnv *, jobject);
JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_segfault(JNIEnv *, jobject);
JNIEXPORT jboolean JNICALL Java_uk_me_mjt_CrashJvm_loadedOk(JNIEnv * a, jobject b);

#endif // CrashJvm_H
