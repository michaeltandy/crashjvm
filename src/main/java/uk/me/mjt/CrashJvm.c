#include "CrashJvm.h"
#include <stdlib.h>

JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_exit(JNIEnv * a, jobject b)
{
    exit(66);
}

JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_abort(JNIEnv * a, jobject b)
{
    abort();
}

JNIEXPORT void JNICALL Java_uk_me_mjt_CrashJvm_segfault(JNIEnv * a, jobject b)
{
    int i = *((int *)0);
}

JNIEXPORT jboolean JNICALL Java_uk_me_mjt_CrashJvm_loadedOk(JNIEnv * a, jobject b)
{
    return JNI_TRUE;
}
