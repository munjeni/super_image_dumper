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
INSTALL=install

DESTDIR=
LIBS=

NDK_BUILD := NDK_PROJECT_PATH=. /root/ndk/android-ndk-r22b/ndk-build NDK_APPLICATION_MK=./Application.mk
NDK2_BUILD := NDK_PROJECT_PATH=. /root/ndk/android-ndk-r22b/ndk-build NDK_APPLICATION_MK=./Application2.mk

VERSION := $(shell sed 's/^.*VERSION //' version.h)

CFLAGS=-Wall -g -O2 -Iinclude
CROSS_CFLAGS=${CFLAGS}

.PHONY: default
default: superunpack

.PHONY: cross
cross: superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11

superunpack: superunpack.c version.h
	${CC} ${CFLAGS} superunpack.c -o superunpack

superunpack.exe: superunpack.c version.h
	sed "s/@VERSION@/$(VERSION)/" superunpack.rc.in >superunpack.rc
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

superrepack.arm64_pie:
	@echo "Building Android pie binary"
	@test -d zlib && echo "" || git clone https://android.googlesource.com/platform/external/zlib -b android-11.0.0_r32
	@test -d fmtlib && echo "" || git clone https://android.googlesource.com/platform/external/fmtlib -b android-11.0.0_r32
	@test -d core && echo "" || git clone https://android.googlesource.com/platform/system/core -b android-11.0.0_r32
	@test -d android_external_e2fsprogs && echo "" || git clone https://github.com/LineageOS/android_external_e2fsprogs.git -b lineage-18.1
	@test -d extras && echo "" || git clone https://android.googlesource.com/platform/system/extras -b android-11.0.0_r35
	@test -d squashfs-tools && echo "" || git clone https://android.googlesource.com/platform/external/squashfs-tools -b android-11.0.0_r35
	@test -d fec && echo "" || git clone https://android.googlesource.com/platform/external/fec -b android-11.0.0_r35
	@test -d avb && echo "" || git clone https://android.googlesource.com/platform/external/avb -b android-11.0.0_r35
	@test -d boringssl && echo "" || git clone https://boringssl.googlesource.com/boringssl
	@test -d pcre && echo "" || git clone https://android.googlesource.com/platform/external/pcre -b android-11.0.0_r35
	@test -d selinux && echo "" || git clone https://android.googlesource.com/platform/external/selinux -b android-11.0.0_r35
	@test -d gsid && echo "" || git clone https://android.googlesource.com/platform/system/gsid -b android-11.0.0_r35
	@test -d vold && echo "" || git clone https://android.googlesource.com/platform/system/vold -b android-11.0.0_r35
	@test -d jsoncpp && echo "" || git clone https://android.googlesource.com/platform/external/jsoncpp -b android-11.0.0_r35
	@test -f lptools.cc && echo "" || wget https://raw.githubusercontent.com/phhusson/device_phh_treble/android-11.0/cmds/lptools.cc -O lptools.cc
	@test -d util-linux-2.27 && echo "" || `wget http://ftp.iij.ad.jp/pub/linux/kernel/linux/utils/util-linux/v2.27/util-linux-2.27.tar.gz && tar xzf util-linux-2.27.tar.gz && rm -rf util-linux-2.27.tar.gz`
	@cp -fr prebuilts/util_linux/config.h util-linux-2.27/
	${NDK2_BUILD}
	@cp -fr libs/arm64-v8a/resize2fs ./resize2fs
	@cp -fr libs/arm64-v8a/e2fsck ./e2fsck
	@cp -fr libs/arm64-v8a/simg2img ./simg2img
	@cp -fr libs/arm64-v8a/img2simg ./img2simg
	@cp -fr libs/arm64-v8a/lptools ./lptools
	@cp -fr libs/arm64-v8a/superrepack.arm64_pie ./superrepack.arm64_pie

superrepack.x86_64:
	${CC} -Wall -O3 -Iinclude  superrepack.cpp -o superrepack.x86_64
	${STRIP} superrepack.x86_64

superunpack.i386-apple-darwin11: superunpack.c version.h
	${CCAPPLE} ${CROSS_CFLAGS} superunpack.c -o superunpack.i386-apple-darwin11
	${CCAPPLESTRIP} superunpack.i386-apple-darwin11

superunpack.x86_64-apple-darwin11: superunpack.c version.h
	${CCAPPLE64} ${CROSS_CFLAGS} superunpack.c -o superunpack.x86_64-apple-darwin11
	${CCAPPLESTRIP64} superunpack.x86_64-apple-darwin11

superunpack.1.gz: superunpack.1
	gzip -9fkn superunpack.1

.PHONY: install
install: superunpack superunpack.1.gz
	$(INSTALL) -o root -g root -d $(DESTDIR)/usr/bin
	$(INSTALL) -o root -g root -m 755 -s superunpack $(DESTDIR)/usr/bin/
	$(INSTALL) -o root -g root -d $(DESTDIR)/usr/share/man/man1
	$(INSTALL) -o root -g root -m 644 -s superunpack.1.gz $(DESTDIR)/usr/share/man/man1

.PHONY: clean
clean:
	rm -rf *.gz *.o *.rc *.res libs obj

.PHONY: distclean
distclean:
	rm -rf *.gz *.o *.rc *.res libs obj superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superrepack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11 superunpack
	rm -rf zlib fmtlib core extras android_external_e2fsprogs squashfs-tools fec avb boringssl pcre selinux gsid vold jsoncpp resize2fs e2fsck simg2img img2simg lptools lptools.cc util-linux-2.27 superrepack_x86_64
