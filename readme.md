This *experimental* software allows you to extract logical partitions from an super dynamic disk image.  

### Usage

- First you must extract superimage e.g. from an super.sin file (Sony firmare) with an tool - search xda for unpack any sony firmware - or use another tool - search xda for unsin
- Run our superunpack tool from command line or if you are on Windows just drop superimage onto superunpack.exe 

### Build (native)

Download, build and install, assuming that `~/bin` is in `$PATH`:

    git clone https://github.com/munjeni/super_image_dumper.git ~/.local/share/superunpack
    make -C ~/.local/share/superunpack
    ln -s ~/.local/share/superunpack/superunpack ~/bin

### Build (cross, static)

`make superunpack.[exe/x64/i386/arm32/arm64/i386-apple-darwin11/x86_64-apple-darwin11]`, exe referring to a Windows build, the rest being for Linux, Android and Darwin11.
arm32_pie and arm_64_pie binaries if you need it you will need to build arm32 or arm64 binaries first. 

### Discussion

[XDA Thread](https://forum.xda-developers.com/crossdevice-dev/sony/tool-superimage-dump-tool-t4120963). 
