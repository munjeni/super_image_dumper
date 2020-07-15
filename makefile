ARMCC=/home/savan/Desktop/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-gcc
ARMSTRIP=/home/savan/Desktop/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-strip

ARMCC64=/home/savan/Desktop/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc
ARMSTRIP64=/home/savan/Desktop/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-strip

CCWIN=i686-w64-mingw32-gcc
CCWINSTRIP=i686-w64-mingw32-strip
WINDRES=i686-w64-mingw32-windres

CCAPPLE64=/home/savan/Desktop/osxtoolchain/osxcross/target/bin/x86_64-apple-darwin11-cc
CCAPPLESTRIP64=/home/savan/Desktop/osxtoolchain/osxcross/target/bin/x86_64-apple-darwin11-strip

CCAPPLE=/home/savan/Desktop/osxtoolchain/osxcross/target/bin/i386-apple-darwin11-cc
CCAPPLESTRIP=/home/savan/Desktop/osxtoolchain/osxcross/target/bin/i386-apple-darwin11-strip

CC=gcc
STRIP=strip

NDK_BUILD := NDK_PROJECT_PATH=. /root/ndk/android-ndk-r21d/ndk-build NDK_APPLICATION_MK=./Application.mk

CFLAGS=-Wall -O2 -Iinclude
CROSS_CFLAGS=${CFLAGS} -Iinclude

.PHONY: default
default: superunpack

.PHONY: cross
cross: superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11

superunpack: superunpack.c version.h
	${CC} ${CFLAGS} $< -o $@

superunpack.exe: superunpack.c version.h superunpack.rc.in
	sed "s/@VERSION@/$$(sed 's/^.*VERSION //' version.h)/" superunpack.rc.in >superunpack.rc
	${WINDRES} superunpack.rc -O coff -o superunpack.res
	${CCWIN} ${CROSS_CFLAGS} -static -mno-ms-bitfields superunpack.c superunpack.res -o superunpack.exe
	${CCWINSTRIP} superunpack.exe

superunpack.x64: superunpack.c version.h
	${CC} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.x64
	${STRIP} superunpack.x64

superunpack.i386: superunpack.c version.h
	${CC} ${CROSS_CFLAGS} -m32 -static superunpack.c -o superunpack.i386
	${STRIP} superunpack.i386

superunpack.arm32: superunpack.c version.h
	${ARMCC} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.arm32
	${ARMSTRIP} superunpack.arm32

superunpack.arm64: superunpack.c version.h
	${ARMCC64} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.arm64
	${ARMSTRIP64} superunpack.arm64

superunpack.arm64_pie:
	@echo "Building Android pie binary"
	${NDK_BUILD}
	@cp -fr libs/arm64-v8a/superunpack.arm64_pie ./superunpack.arm64_pie

superunpack.i386-apple-darwin11: superunpack.c version.h
	${CCAPPLE} ${CROSS_CFLAGS} superunpack.c -o superunpack.i386-apple-darwin11
	${CCAPPLESTRIP} superunpack.i386-apple-darwin11

superunpack.x86_64-apple-darwin11: superunpack.c version.h
	${CCAPPLE64} ${CROSS_CFLAGS} superunpack.c -o superunpack.x86_64-apple-darwin11
	${CCAPPLESTRIP64} superunpack.x86_64-apple-darwin11

.PHONY: clean
clean:
	rm -rf *.o *.rc *.res libs obj

.PHONY: distclean
distclean:
	rm -rf *.o *.rc *.res libs obj superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11 superunpack
