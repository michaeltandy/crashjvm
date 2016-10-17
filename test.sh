#!/bin/bash

cp target/crashjvm-*.jar target/jar\ with\ filename\ spaces.jar

java -cp target/jar\ with\ filename\ spaces.jar uk.me.mjt.CrashJvm exit
lastStatus=$?
if [ $lastStatus -ne 66 ]; then
  echo "Wrong exit code calling exit? Saw $lastStatus" >&2
  exit $lastStatus
fi

java -cp target/jar\ with\ filename\ spaces.jar uk.me.mjt.CrashJvm abort
lastStatus=$?
if [ $lastStatus -ne 134 ] && [ $lastStatus -ne 127 ]; then
  echo "Wrong exit code calling abort? Saw $lastStatus" >&2
  exit $lastStatus
fi

java -cp target/jar\ with\ filename\ spaces.jar uk.me.mjt.CrashJvm segfault
lastStatus=$?
if [ $lastStatus -ne 134 ] && [ $lastStatus -ne 1 ]; then
  echo "Wrong exit code calling segfault? Saw $lastStatus" >&2
  exit $lastStatus
fi

echo -e "\n\nTest successful - saw expected crashes!" >&2
