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

NDK_BUILD := NDK_PROJECT_PATH=. /root/ndk/android-ndk-r21d/ndk-build NDK_APPLICATION_MK=./Application.mk

VERSION := $(shell sed 's/^.*VERSION //' version.h)

CFLAGS=-Wall -g -O2 -Iinclude
CROSS_CFLAGS=${CFLAGS}

.PHONY: default
default: superunpack

.PHONY: cross
cross: superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11

superunpack: superunpack.c version.h
	${CC} ${CFLAGS} superunpack.c -o superunpack
	${CC} ${CFLAGS} superrepack.c -o superrepack

superunpack.exe: superunpack.c version.h
	sed "s/@VERSION@/$(VERSION)/" superunpack.rc.in >superunpack.rc
	sed "s/@VERSION@/$(VERSION)/" superrepack.rc.in >superrepack.rc
	${WINDRES} superunpack.rc -O coff -o superunpack.res
	${WINDRES} superrepack.rc -O coff -o superrepack.res
	${CCWIN} ${CROSS_CFLAGS} -static -mno-ms-bitfields superunpack.c superunpack.res -o superunpack.exe
	${CCWIN} ${CROSS_CFLAGS} -static -mno-ms-bitfields superrepack.c superrepack.res -o superrepack.exe
	${CCWINSTRIP} superunpack.exe
	${CCWINSTRIP} superrepack.exe

superunpack.x64: superunpack.c version.h
	${CC} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.x64
	${STRIP} superunpack.x64
	${CC} ${CROSS_CFLAGS} -static superrepack.c -o superrepack.x64
	${STRIP} superrepack.x64

superunpack.i386: superunpack.c version.h
	${CC} ${CROSS_CFLAGS} -m32 -static superunpack.c -o superunpack.i386
	${STRIP} superunpack.i386
	${CC} ${CROSS_CFLAGS} -m32 -static superrepack.c -o superrepack.i386
	${STRIP} superrepack.i386

superunpack.arm32: superunpack.c version.h
	${ARMCC} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.arm32
	${ARMSTRIP} superunpack.arm32
	${ARMCC} ${CROSS_CFLAGS} -static superrepack.c -o superrepack.arm32
	${ARMSTRIP} superrepack.arm32

superunpack.arm64: superunpack.c version.h
	${ARMCC64} ${CROSS_CFLAGS} -static superunpack.c -o superunpack.arm64
	${ARMSTRIP64} superunpack.arm64
	${ARMCC64} ${CROSS_CFLAGS} -static superrepack.c -o superrepack.arm64
	${ARMSTRIP64} superrepack.arm64

superunpack.arm64_pie:
	@echo "Building Android pie binary"
	${NDK_BUILD}
	@cp -fr libs/arm64-v8a/superunpack.arm64_pie ./superunpack.arm64_pie
	@cp -fr libs/arm64-v8a/superrepack.arm64_pie ./superrepack.arm64_pie

superunpack.i386-apple-darwin11: superunpack.c version.h
	${CCAPPLE} ${CROSS_CFLAGS} superunpack.c -o superunpack.i386-apple-darwin11
	${CCAPPLESTRIP} superunpack.i386-apple-darwin11
	${CCAPPLE} ${CROSS_CFLAGS} superrepack.c -o superrepack.i386-apple-darwin11
	${CCAPPLESTRIP} superrepack.i386-apple-darwin11

superunpack.x86_64-apple-darwin11: superunpack.c version.h
	${CCAPPLE64} ${CROSS_CFLAGS} superunpack.c -o superunpack.x86_64-apple-darwin11
	${CCAPPLESTRIP64} superunpack.x86_64-apple-darwin11
	${CCAPPLE64} ${CROSS_CFLAGS} superrepack.c -o superrepack.x86_64-apple-darwin11
	${CCAPPLESTRIP64} superrepack.x86_64-apple-darwin11

superunpack.1.gz: superunpack.1
	gzip -9fkn superunpack.1

.PHONY: install
install: superunpack superunpack.1.gz
	$(INSTALL) -o root -g root -d $(DESTDIR)/usr/bin
	$(INSTALL) -o root -g root -m 755 -s superunpack $(DESTDIR)/usr/bin/
	$(INSTALL) -o root -g root -m 755 -s superrepack $(DESTDIR)/usr/bin/
	$(INSTALL) -o root -g root -d $(DESTDIR)/usr/share/man/man1
	$(INSTALL) -o root -g root -m 644 -s superunpack.1.gz $(DESTDIR)/usr/share/man/man1

.PHONY: clean
clean:
	rm -rf *.gz *.o *.rc *.res libs obj

.PHONY: distclean
distclean:
	rm -rf *.gz *.o *.rc *.res libs obj superunpack.exe superunpack.x64 superunpack.i386 superunpack.arm32 superunpack.arm64 superunpack.arm64_pie superunpack.i386-apple-darwin11 superunpack.x86_64-apple-darwin11 superunpack
	rm -rf superrepack.exe superrepack.x64 superrepack.i386 superrepack.arm32 superrepack.arm64 superrepack.arm64_pie superrepack.i386-apple-darwin11 superrepack.x86_64-apple-darwin11 superrepack
