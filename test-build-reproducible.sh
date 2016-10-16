#!/bin/bash
set -e

mvn clean install > /dev/null
SUM_BEFORE=$(shasum -a 512 target/crashjvm-*.jar)

mvn clean install > /dev/null
SUM_REBUILT=$(shasum -a 512 target/crashjvm-*.jar)

if [ "$SUM_BEFORE" != "$SUM_REBUILT" ]; then
  echo "Checksum changed when rebuilt?" >&2
  echo "Before: $SUM_BEFORE" >&2
  echo "After rebuilt: $SUM_REBUILT" >&2
  exit 1
else
  echo "Checksum unchanged when rebuilt - good sign for build reproducibility" >&2
fi
