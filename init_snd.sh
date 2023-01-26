#!/usr/bin/env bash

echo "Initialising sound devices" 

for x in {a..p}
do
    echo "zone_$x"
    timeout 0.1 speaker-test -D zone_$x > /dev/null 2>&1
done

echo "Done"
