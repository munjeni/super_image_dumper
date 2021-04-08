This *experimental* software allows you to extract or modify logical partitions from an super dynamic disk image.  

### Superunpack usage

- First you must extract superimage e.g. from an super.sin file (Sony firmare) with an tool - search xda for unpack any sony firmware - or use another tool - search xda for unsin
- Run our superunpack tool from command line or if you are on Windows just drop superimage onto superunpack.exe
- If you need to extract superimage with RW support add parameter 1 to the end of command line e.g. superunpack super.img 1, if you do that you need to resize2fs it and repair it with e2fsck -fy -E unshare_blocks

### Superrepack usage

- This is for Android only. This tool is designed to convert your ro partitions inside dynamic disk to the rw. For more info see bootom forum link.

### Build Superunpack (native)

Download, build and install, assuming that `~/bin` is in `$PATH`:

    git clone https://github.com/munjeni/super_image_dumper.git ~/.local/share/superunpack
    make -C ~/.local/share/superunpack
    ln -s ~/.local/share/superunpack/superunpack ~/bin

### Build Superunpack and Superrepack (cross, static)

`make superunpack.[exe/x64/i386/arm32/arm64/arm64_pie/i386-apple-darwin11/x86_64-apple-darwin11]`, exe referring to a Windows build, the rest being for Linux, Android and Darwin11, arm64_pie binaries

`make superrepack.arm64_pie` Android pie binary.

### Discussion

[XDA Thread](https://forum.xda-developers.com/crossdevice-dev/sony/tool-superimage-dump-tool-t4120963). 
