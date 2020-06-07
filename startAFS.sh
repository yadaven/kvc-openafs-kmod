#!/usr/bin/env bash

insmod /build/openafs-1.8.5/src/libafs/MODLOAD-4.18.0-147.8.1.el8_1.x86_64-SP/openafs.ko
if [ ! -d "/openafs/afscache" ]; then
	mkdir /openafs/afscache
fi
if [ ! -d "/openafs/afs" ]; then
	mkdir /openafs/afs
fi
/build/openafs-1.8.5/src/afsd/afsd -stat 100000 -daemons 12 -volumes 1536 -chunksize 20 -files 115000 -dcache 25000 -disable-dynamic-vcaches --mountdir=/openafs/afs
