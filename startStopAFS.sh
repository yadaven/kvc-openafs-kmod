#!/usr/bin/env bash

function usage() {
	echo "$0 -o <start|stop>"
	exit
}

operation=""
kversion=""

while getopts "o:v:" c; do

	case $c in 
		o) operation=$OPTARG;;
	   	v) kversion=$OPTARG;;
	esac			
done

[ -z $operation ] && usage
[ -z $kversion ] && usage


if [ $operation = "start" ]; then

	cp /build/openafs-1.8.5/src/libafs/MODLOAD-${kversion}/openafs.ko /lib/modules/${kversion}/
	depmod -a
	if [ ! -d "/openafs/afscache" ]; then
		mkdir /openafs/afscache
	fi
	if [ ! -d "/openafs/afs" ]; then
		mkdir /openafs/afs
	fi
	modprobe openafs
	/build/openafs-1.8.5/src/afsd/afsd -stat 100000 -daemons 12 -volumes 1536 -chunksize 20 -files 115000 -dcache 25000 -disable-dynamic-vcaches --mountdir=/openafs/afs
elif [ $operation = "stop" ]; then
	umount /openafs/afs
	/build/openafs-1.8.5/src/afsd/afsd -shutdown
	rmmod openafs
fi
