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
if [ $lastStatus -ne 134 ]; then
  echo "Wrong exit code calling abort? Saw $lastStatus" >&2
  exit $lastStatus
fi

java -cp target/jar\ with\ filename\ spaces.jar uk.me.mjt.CrashJvm segfault
lastStatus=$?
if [ $lastStatus -ne 134 ]; then
  echo "Wrong exit code calling segfault? Saw $lastStatus" >&2
  exit $lastStatus
fi

echo -e "\n\nTests all as expected! SHA1 checksum of build artifact:"
shasum -a 1 target/crashjvm-*.jar
echo "SHA512 checksum of same:"
shasum -a 512 target/crashjvm-*.jar
