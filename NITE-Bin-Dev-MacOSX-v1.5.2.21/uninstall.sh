#!/bin/bash 

if [ "`uname -s`" == "Darwin" ]; then
        LIBEXT="dylib"
else
        LIBEXT="so"
fi

for fmod in `ls -1 /usr/local/lib/libXnVFeatures*$LIBEXT`
do
	niReg -u $fmod
done
for hmod in `ls -1 /usr/local/lib/libXnVHandGenerator*$LIBEXT`
do
	niReg -u $hmod
done

rm /usr/local/lib/libXnVNite*$LIBEXT
rm /usr/local/lib/libXnVCNITE*$LIBEXT
rm /usr/local/lib/libXnVNITE.jni*$LIBEXT
rm /usr/local/lib/libXnVFeatures*$LIBEXT
rm /usr/local/lib/libXnVHandGenerator*$LIBEXT
rm -rf /usr/local/bin/XnVSceneServer*
rm -rf /usr/local/etc/primesense/Features*
rm -rf /usr/local/etc/primesense/Hands*
rm -rf /usr/local/include/nite/
rm /usr/local/share/java/com.primesense.NITE.jar


if [ -f /usr/local/bin/gmcs ]
then
	if [ -e /usr/local/etc/primesense/XnVNITE.net.dll.list ]
	then
		for netdll in `cat /usr/local/etc/primesense/XnVNITE.net.dll.list`
		do
			netdll=`echo $netdll | sed "s/\.dll//"`
			gacutil -u $netdll
		done
		rm -rf /usr/local/etc/primesense/XnVNITE.net.dll.list
	fi
fi

echo "Done!"
