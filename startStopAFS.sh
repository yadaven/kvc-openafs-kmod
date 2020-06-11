#!/usr/bin/env bash

function usage() {
	echo "$0 -o <start|stop> -v <kernel version> -s <software version>"
	exit
}

operation=""
kversion=""
softwareVersion=""

while getopts "o:v:s:" c; do

	case $c in 
		o) operation=$OPTARG;;
	   	v) kversion=$OPTARG;;
		s) softwareVersion=$OPTARG;;
	esac			
done

[ -z $operation ] && usage
[ -z $kversion ] && usage
[ -z $softwareVersion ] && usage


if [ $operation = "start" ]; then

	cp /openafs/ThisCell /usr/vice/etc/
	cp /openafs/CellServDB /usr/vice/etc/
	cp /openafs/krb5.conf /etc
	cp /build/openafs-${softwareVersion}/src/libafs/MODLOAD-${kversion}/openafs.ko /lib/modules/${kversion}/
	depmod -a
	if [ ! -d "/openafs/afscache" ]; then
		mkdir /openafs/afscache
	fi
	if [ ! -d "/openafs/afs" ]; then
		mkdir /openafs/afs
	fi
	modprobe openafs
	/build/openafs-${softwareVersion}/src/afsd/afsd -stat 100000 -daemons 12 -volumes 1536 -chunksize 20 -files 115000 -dcache 25000 -disable-dynamic-vcaches --mountdir=/openafs/afs
elif [ $operation = "stop" ]; then
	umount /openafs/afs
	/build/openafs-${softwareVersion}/src/afsd/afsd -shutdown
	rmmod openafs
fi
