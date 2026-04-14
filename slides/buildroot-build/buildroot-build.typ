#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "typst/local/themeBootlin.typ": *

#import "typst/local/common.typ": *

#show: bootlin-theme.with( aspect-ratio: "16-9",
config-common(handout: "handout" in sys.inputs and sys.inputs.handout
== "1", ))

#show raw.where(block: true): set block(fill: luma(240), inset: 1em,
radius: 0.5em, width: 100%)


#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): set block(fill: luma(240),
inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt,
below: 12pt)

#show raw.where(lang: "c", block: true): set text(11pt)

#show raw.where(lang: "console", block: true):set block(fill:
luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true,
above: 6pt)

#show raw.where(lang:"console", block: true): set text(12pt)

= Managing the build and the configuration

===  Default build organization

- All the build output goes into a directory called `output/` within the
  top-level Buildroot source directory.

  - `O = output`#v(0.3em)

- The configuration file is stored as `.config` in the top-level
  Buildroot source directory.

  - `CONFIG_DIR = $(TOPDIR)`

  - `TOPDIR = $(shell pwd)`#v(0.3em)

- `buildroot/`

  - #strong[`.config`]

  - `arch/`

  - `package/`

  - #strong[`output/`]

  - `fs/`

  - ...

===  Out of tree build: introduction

- Out of tree build allows to use an output directory different than
  `output/`#v(0.3em)

- Useful to build different Buildroot configurations from the same
  source tree.#v(0.3em)

- Customization of the output directory done by passing
  `O=/path/to/directory` on the command line.#v(0.3em)

- Configuration file stored inside the `$(O)` directory, as opposed to
  inside the Buildroot sources for the in-tree build case.#v(0.3em)

- `project/`

  - `buildroot/`, Buildroot sources

  - `foo-output/`, output of a first project

    - `.config`#v(0.3em)

  - `bar-output/`, output of a second project

    - `.config`

===  Out of tree build: using

- To start an out of tree build, two solutions:#v(0.3em)

  - From the Buildroot source tree, simplify specify a `O=` variable:#v(0.3em)

    ```
    make O=../foo-output/ menuconfig
    ```#v(0.3em)
  - From an empty output directory, specify `O=` and the path to the
    Buildroot source tree:#v(0.3em)

    ```
    make -C ../buildroot/ O=$(pwd) menuconfig
    ```
#v(0.3em)
- Once one out of tree operation has been done (`menuconfig`, loading a
  defconfig, etc.), Buildroot creates a small wrapper `Makefile` in the
  output directory.#v(0.3em)

- This wrapper `Makefile` then avoids the need to pass `O=` and the
  path to the Buildroot source tree.

===  Out of tree build: example

+ You are in your Buildroot source tree: 

  #[
    #set text(size:12pt)
    ```
    $ ls arch board boot ... Makefile ... package ...
    ```
  ]

+ Create a new output directory, and move to it: 

  #[
    #set text(size:12pt)
    ```
    $ mkdir ../foobar-output
    $ cd ../foobar-output
    ```
  ]

+ Start a new Buildroot configuration: 

  #[
    #set text(size:12pt)
    ```
    $ make -C ../buildroot O=$(pwd) menuconfig
    ```
  ]

+ Start the build (passing `O=` and `-C` no longer needed thanks to the
  wrapper): 

  #[
    #set text(size:12pt)
    ```
    $ make
    ```
  ]

+ Adjust the configuration again, restart the build, clean the build: 

  #[
    #set text(size:12pt)

    ```
    $ make menuconfig
    $ make
    $ make clean
    ```
  ]
===  Full config file vs. #emph[defconfig]

- The `.config` file is a #emph[full] config file: it contains the value
  for all options (except those having unmet dependencies)#v(0.3em)

- The default `.config`, without any customization, has 4742 lines (as
  of Buildroot 2024.02)#v(0.3em)

  - Not very practical for reading and modifying by humans.#v(0.3em)

- A #emph[defconfig] stores only the values for options for which the
  non-default value is chosen.#v(0.3em)

  - Much easier to read

  - Can be modified by humans

  - Can be used for automated construction of configurations

===  #emph[defconfig]: example

- For the default Buildroot configuration, the #emph[defconfig] is
  empty: everything is the default.#v(0.3em)

- If you change the architecture to be ARM, the #emph[defconfig] is just
  one line:#v(0.3em)

  ```
  BR2_arm=y
  ```#v(0.3em)

- If then you also enable the `stress` package, the #emph[defconfig]
  will be just two lines:#v(0.3em)

  ```
  BR2_arm=y BR2_PACKAGE_STRESS=y
  ```

===  Using and creating a #emph[defconfig]

- To use a #emph[defconfig], copying it to `.config` is not sufficient
  as all the missing (default) options need to be expanded.#v(0.3em)

- Buildroot allows to load #emph[defconfig] stored in the `configs/`
  directory, by doing: #linebreak()`make <foo>_defconfig`

  - It overwrites the current `.config`, if any#v(0.3em)

- To create a #emph[defconfig], run: 
  `make savedefconfig`#v(0.3em)

  - Saved in the file pointed by the `BR2_DEFCONFIG` configuration
    option

  - By default, points to `defconfig` in the current directory if the
    configuration was started from scratch, or points to the original
    #emph[defconfig] if the configuration was loaded from a defconfig.

  - Move it to `configs/` to make it easily loadable with `make <foo>_defconfig`.

===  Existing #emph[defconfigs]

- Buildroot comes with a number of existing #emph[defconfigs] for
  various publicly available hardware platforms:

  - RaspberryPi, BeagleBone Black, CubieBoard, Microchip evaluation
    boards, Minnowboard, various i.MX6 boards

  - QEMU emulated platforms#v(0.3em)

- List them using `make list-defconfigs`#v(0.3em)

- Most built-in #emph[defconfigs] are minimal: only build a toolchain,
  bootloader, kernel and minimal root filesystem.#v(0.3em)

  ```
  $ make qemu_arm_vexpress_defconfig
  $ make
  ```
#v(0.3em)
- Additional instructions often available in `board/<boardname>`,
  e.g.: `board/qemu/arm-vexpress/readme.txt`.#v(0.3em)

- Your own #emph[defconfigs] can obviously be more featureful

===  Assembling a #emph[defconfig] (1/2)
#[
  #set text(size: 19pt)
- #emph[defconfigs] are trivial text files, one can use simple
  concatenation to assemble them from fragments.
]

#v(0.3em)

#[
  #set text(size: 14.5pt)
platform1.frag
]
#[
  #set text(size: 17pt)
```
BR2_arm=y 
BR2_TOOLCHAIN_BUILDROOT_WCHAR=y 
BR2_GCC_VERSION_7_X=y
```
]
#v(0.8em)
#[
  #set text(size: 14.5pt)
platform2.frag
]
#[
  #set text(size: 17pt)
```
BR2_mipsel=y 
BR2_TOOLCHAIN_EXTERNAL=y 
BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS=y
```
]
#v(0.8em)
#[
  #set text(size: 14.5pt)
packages.frag
]
#[
  #set text(size: 17pt)
```
BR2_PACKAGE_STRESS=y 
BR2_PACKAGE_MTD=y 
BR2_PACKAGE_LIBCONFIG=y
```
]
===  Assembling a #emph[defconfig] (2/2)
#[
  #set text(size: 14.5pt)
debug.frag
]
#[
  #set text(size: 17pt)
```
BR2_ENABLE_DEBUG=y BR2_PACKAGE_STRACE=y
```]#v(1em)
#[
  #set text(size: 14.5pt)
Build a release system for #emph[platform1]
]
#[
  #set text(size: 17pt)
```
$ ./support/kconfig/merge_config.sh platform1.frag packages.frag
$ make
```]#v(1em)
#[
  #set text(size: 14.5pt)
Build a debug system for #emph[platform2]
]
#[
  #set text(size: 17pt)
```
$ ./support/kconfig/merge_config.sh platform2.frag packages.frag 
        debug.frag
$ make
```
]
#v(1em)

- Saving fragments is not possible; it must be done manually from an
  existing #emph[defconfig]

===  Other building tips

- Cleaning targets

  - Cleaning all the build output, but keeping the configuration file:
  

    ```
      $ make clean
    ```

  - Cleaning everything, including the configuration file, and
    downloaded file if at the default location:
    #[
      #set text(size: 17pt)
    ```
      $ make distclean
    ```]

#v(0.3em)
- Verbose build

  - By default, Buildroot hides a number of commands it runs during the
    build, only showing the most important ones.

  - Passing `V=1` also applies to packages, like the Linux kernel,
    busybox...

  - To get a fully verbose build, pass `V=1`:

#[
  #set text(size: 17pt)
    ```
      $ make V=1
    ```
]
#v(0.3em)

    
