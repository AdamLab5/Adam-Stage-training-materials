#import "@local/bootlin:0.1.0": *
#import "@local/bootlin-yocto:0.1.0": *
#import "@local/bootlin-utils:0.1.0": *

#show: bootlin-theme.with(
  aspect-ratio: "16-9",
  config-info(
  title: [#text(size: 0.9em)[Yocto Project and OpenEmbedded:\ Recent Changes and Future Directions]],
  author: [#v(-30pt)#text(size: 0.8em)[Antonin Godard\ _antonin.godard\@bootlin.com_]],
  date: [#v(-30pt)#text(size: 0.8em)[Embedded Recipes 2025]],
  institution: [Bootlin],
),
config-common(
  // Compile with `typst c --input handout=1 ...` to generate the handout.
  handout: "handout" in sys.inputs and sys.inputs.handout == "1",
))
=  Toolchains in Buildroot
<toolchains-in-buildroot>
===  What is a cross-compilation toolchain?

- A set of tools to build and debug code for a target architecture, from
  a machine running a different architecture.

- Example: building code for ARM from a x86-64 PC.

#image("slides/buildroot-toolchain/components.pdf", height: 60%)

===  Two possibilities for the toolchain

===  Internal toolchain backend

- Makes Buildroot build the entire cross-compilation toolchain from
  source.

- Provides a lot of flexibility in the configuration of the toolchain.

  - Kernel headers version

  - C library: Buildroot supports uClibc, (e)glibc and musl

    - glibc, the standard C library. Good choice if you don’t have tight
      space constraints ($gt eq$ 10 MB)

    - uClibc-ng and musl, smaller C libraries. uClibc-ng supports
      non-MMU architectures. Good for very small systems ($lt$ 10 MB).

  - Different versions of binutils and gcc. Keep the default versions
    unless you have specific needs.

  - Numerous toolchain options: C++, LTO, OpenMP, libmudflap, graphite,
    and more depending on the selected C library.

- Building a toolchain takes quite some time: 15-20 minutes on
  moderately recent machines.

===  Internal toolchain backend: result

-  ``` host/bin/\<tuple\>-\<tool\> ``` , the cross-compilation tools:
  compiler, linker, assembler, and more. The compiler is hidden behind a
  wrapper program.

-  ``` host/\<tuple\>/ ``` 

  -  ``` sysroot/usr/include/ ``` , the kernel headers and C library headers

  -  ``` sysroot/lib/ ```  and  ``` sysroot/usr/lib/ ``` , C library and gcc runtime

  -  ``` include/c++/ ``` , C++ library headers

  -  ``` lib/ ``` , host libraries needed by gcc/binutils

-  ``` target/ ``` 

  -  ``` lib/ ```  and  ``` usr/lib/ ``` , C and C++ libraries

- The compiler is configured to:

  - generate code for the architecture, variant, FPU and ABI selected in
    the  ``` Target options ``` 

  - look for libraries and headers in the #emph[sysroot]

  - no need to pass weird gcc flags!

===  External toolchain backend possibilities

- Allows to re-use existing pre-built toolchains

- Great to:

  - save the build time of the toolchain

  - use vendor provided toolchain that are supposed to be reliable

- Several options:

  - Use an existing toolchain profile known by Buildroot

  - Download and install a custom external toolchain

  - Directly use a pre-installed custom external toolchain

===  Existing external toolchain profile

- Buildroot already knows about a wide selection of publicly available
  toolchains.

- Toolchains from

  - ARM (ARM and AArch64)

  - Mentor Graphics (AArch64, ARM, MIPS, NIOS-II)

  - Imagination Technologies (MIPS)

  - Synopsys (ARC)

  - Bootlin

- In such cases, Buildroot is able to download and automatically use the
  toolchain.

- It already knows the toolchain configuration: C library being used,
  kernel headers version, etc.

- Additional profiles can easily be added.

#image("../../slides/buildroot-toolchain/external-toolchain-profiles.png", width: 100%)

===  Existing external toolchains: Bootlin toolchains

- #link("https://toolchains.bootlin.com")

- A set of 218 pre-built toolchains, freely available

  - 43 different CPU architecture variants

  - All possible C libraries supported: glibc, uClibc-ng, musl

  - Toolchains built with Buildroot!

- Two versions for each toolchain

  - #emph[stable], which uses the default version of gcc, binutils and
    gdb in Buildroot

  - #emph[bleeding-edge], which uses the latest version of gcc, binutils
    and gdb in Buildroot

- Directly integrated in Buildroot

#image("../../slides/buildroot-toolchain/bootlin-toolchains-com.png", height: 50%)
#image("../../slides/buildroot-toolchain/bootlin-toolchains-menuconfig.png", width: 80%)

===  Custom external toolchains

- If you have a custom external toolchain, for example from your vendor,
  select  ``` Custom toolchain ```  in  ``` Toolchain ``` .

- Buildroot can download and extract it for you

  - Convenient to share toolchains between several developers

  - Option  ``` Toolchain to be downloaded and installed ```  in  ``` Toolchain
    origin ``` 

  - The URL of the toolchain tarball is needed

- Or Buildroot can use an already installed toolchain

  - Option  ``` Pre-installed toolchain ```  in  ``` Toolchain origin ``` 

  - The local path to the toolchain is needed

- In both cases, you will have to tell Buildroot the configuration of
  the toolchain: C library, kernel headers version, etc.

  - Buildroot needs this information to know which packages can be built
    with this toolchain

  - Buildroot will check those values at the beginning of the build

===  Custom external toolchain example configuration

#image("../../slides/buildroot-toolchain/external-toolchain-config.png", height: 80%)

===  External toolchain: result

-  ``` host/opt/ext-toolchain ``` , where the original toolchain tarball is
  extracted. Except when a local pre-installed toolchain is used.

-  ``` host/bin/\<tuple\>-\<tool\> ``` , symbolic links to the
  cross-compilation tools in their original location. Except the
  compiler, which points to a wrapper program.

-  ``` host/\<tuple\>/ ``` 

  -  ``` sysroot/usr/include/ ``` , the kernel headers and C library headers

  -  ``` sysroot/lib/ ```  and  ``` sysroot/usr/lib/ ``` , C library and gcc runtime

  -  ``` include/c++/ ``` , C++ library headers

-  ``` target/ ``` 

  -  ``` lib/ ```  and  ``` usr/lib/ ``` , C and C++ libraries

- The wrapper takes care of passing the appropriate flags to the
  compiler.

  - Mimics the internal toolchain behavior

===  Kernel headers version

- One option in the toolchain menu is particularly important: the kernel
  headers version.

- When building user space programs, libraries or the C library, kernel
  headers are used to know how to interface with the kernel.

- This kernel/user space interface is #strong[backward compatible], but
  can introduce new features.

- It is therefore important to use kernel headers that have a version
  #strong[equal or older] than the kernel version running on the target.

- With the internal toolchain backend, choose an appropriate kernel
  headers version.

- With the external toolchain backend, beware when choosing your
  toolchain.

===  Other toolchain menu options

- The toolchain menu offers a few other options:

  - #emph[Target optimizations]

    - Allows to pass additional compiler flags when building target
      packages

    - Do not pass flags to select a CPU or FPU, these are already passed
      by Buildroot

    - Be careful with the flags you pass, they affect the entire build

  - #emph[Target linker options]

    - Allows to pass additional linker flags when building target
      packages

  - gdb/debugging related options

    - Covered in our #emph[Application development] section later.
