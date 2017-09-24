#!/bin/bash -e

if [ "`uname -s`" == "Darwin" ]; then
        LIBEXT="dylib"
else
        LIBEXT="so"
fi

printf "Installing NITE\n"
printf "***************\n\n"

printf "Copying shared libraries... "
cp Bin/libXnVNite*$LIBEXT /usr/local/lib
cp Bin/libXnVCNITE*$LIBEXT /usr/local/lib
cp Bin/libXnVNITE.jni*$LIBEXT /usr/local/lib
printf "OK\n"

# If samples exist then this is a development installation, so headers are needed
if [ -e Samples/Build/Makefile ]
then
	printf "Copying includes... "
	mkdir -p /usr/local/include/nite
	cp Include/* /usr/local/include/nite
	printf "OK\n"
fi

printf "Installing java bindings... "
cp Bin/com.primesense.NITE.jar /usr/local/share/java/
printf "OK\n"

for fdir in `ls -1 | grep Features`
do
	printf "Installing module '$fdir'...\n"
	mkdir -p /usr/local/etc/primesense/$fdir
	cp -r $fdir/Data/* /usr/local/etc/primesense/$fdir
	for so in `ls -1 $fdir/Bin/lib*$LIBEXT`
	do
		base=`basename $so`
		printf "Registering module '$base'... "
		cp $so /usr/local/lib
		niReg /usr/local/lib/$base /usr/local/etc/primesense/$fdir
		printf "OK\n"
	done
	for bin in `ls -1 $fdir/Bin | grep XnVSceneServer`
	do
		printf "Copying XnVSceneServer... "
		full=$fdir/Bin/$bin
		cp $full /usr/local/bin
		chmod +x /usr/local/bin/$bin
		printf "OK\n"
	done
done
for hdir in `ls -1 | grep Hands`
do
	printf "Installing module '$fdir'\n"
	mkdir -p /usr/local/etc/primesense/$hdir
	cp -r $hdir/Data/* /usr/local/etc/primesense/$hdir
	for so in `ls -1 $hdir/Bin/lib*$LIBEXT`
	do
		base=`basename $so`
		printf "registering module '$base'..."
		cp $so /usr/local/lib
		niReg /usr/local/lib/$base /usr/local/etc/primesense/$hdir
		printf "OK\n"
	done
done

if [ -f /usr/local/bin/gmcs ]
then
	printf "Installing .NET wrappers...\n"
	for net in `ls -1 Bin/*dll`
	do
		gacutil -i $net -package 2.0
		netdll=`basename $net`
		echo $netdll >> /usr/local/etc/primesense/XnVNITE.net.dll.list
	done
fi

printf "Adding license.. "
LIC_KEY=""
ASK_LIC="1"
while (( "$#" )); do
	case "$1" in
	-l=*)
		ASK_LIC="0"
		LIC_KEY=${1:3}
		;;
	esac
	shift
done
niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4=
printf "OK\n"

if [ -e Makefile ]
then
	printf "Running make...\n"
	make
fi

printf "\n*** DONE ***\n\n"
