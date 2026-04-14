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

#show raw.where(block: true): set text(size: 11pt)

#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): set block(fill: luma(240),
inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt,
below: 12pt)

#show raw.where(lang: "c", block: true): set text(11pt)

#show raw.where(lang: "console", block: true):set block(fill:
luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true,
above: 6pt)

#show raw.where(lang:"console", block: true): set text(12pt)

= Embedded system building tools

===  Approaches Three main approaches to build your embedded Linux
system:

+ Cross-compile everything manually from source

+ Use a binary distribution such as Debian, Ubuntu or Fedora

+ Use an #emph[embedded Linux build system] that automates the
  cross-compilation process

===  Approaches pros and cons

#align(center)[
#table(
  columns: 3,
  align: (col, row) => (left,left,left,).at(col),
  inset: 6pt,
  [], [#strong[Pros]], [#strong[Cons]],
  [#strong[Building everything manually]],
  [Full flexibility Learning experience],
  [Dependency hell Need to understand a lot of details Version
  compatibility Lack of reproducibility],
  [#strong[Binary distribution] Debian, Ubuntu, Fedora, etc.],
  [Easy to create and extend Extensive set of packages Usually excellent
  security maintenance],
  [Hard to customize Hard to optimize (boot time, size) Hard to rebuild
  the full system from source Large system Uses native compilation
  (slow) No well-defined mechanism to generate an image Lots of
  mandatory dependencies Not available for all architectures],
  [#strong[Embedded Linux Build systems] Buildroot, Yocto, PTXdist,
  OpenWrt, etc.],
  [Nearly full flexibility Built from source: customization and
  optimization are easy Fully reproducible Uses cross-compilation Have
  embedded specific packages not necessarily in desktop distros Make
  more features optional],
  [Not as easy as a binary distribution Build time],
)
])

== Embedded Linux build systems
<embedded-linux-build-systems>
===  Embedded Linux build system: principle

#align(center, [#image("buildsystem-principle.pdf", width: 90%)])

- Building from source \$arrow.r\$\_lot of flexibility

- Cross-compilation \$arrow.r\$\_leveraging fast build machines

- Recipes for building components \$arrow.r\$\_easy

===  Build systems vs. Embedded Linux build systems


#table(columns: (50%, 50%), stroke: none, [

- Possible confusion between #emph[build system] (Makefiles, autotools,
  CMake, Meson) and #emph[embedded Linux build systems] (Buildroot,
  Yocto/OpenEmbedded, OpenWrt, etc.)

- #emph[Build systems] are used by individual software components, to
  control the build process of each source file into a library,
  executable, documentation, etc.

- #emph[Embedded Linux build systems] are tools that orchestrate the
  build of all software components one after the other. They invoke the
  #emph[build system] of each software component.

#align(center, [#image("build-system-vs-embedded-linux-build-system.pdf", height: 80%)])


])

===  Buildroot: introduction


#table(columns: (50%, 50%), stroke: none, [
#align(center, [#image("buildroot-logo.png", height: 100%)])

- Allows to build a toolchain, a root filesystem image with many
  applications and libraries, a bootloader and a kernel image

  - Or any combination of the previous items

- Supports using uClibc, glibc and musl toolchains, either built by
  Buildroot, or external

- Over 2800 applications or libraries integrated, from basic utilities
  to more elaborate software stacks: Wayland, GStreamer, Qt, Gtk,
  WebKit, Python, PHP, NodeJS, Go, Rust, etc.

- Good for small to medium size embedded systems, with a fixed set of
  features

  - No support for generating packages (`.deb` or `.ipk`)

  - Needs complete rebuild for most configuration changes.

- Active community, releases published every 3 months. One LTS release
  made every year (`YYYY.02` so far).


])

===  Buildroot: configuration and build


#table(columns: (50%, 50%), stroke: none, [

- Configuration takes place through a `*config` interface similar to
  the kernel 
  `make menuconfig`

- Allows to define

  - Architecture and specific CPU

  - Toolchain configuration

  - Set of applications and libraries to integrate

  - Filesystem images to generate

  - Kernel and bootloader configuration

- Build: 
  `make`

- Useful build results in `output/images/`

#align(center, [#image("buildroot-screenshot.png", width: 100%)])

])

===  Buildroot: adding a new package

- A package allows to integrate a user application or library to
  Buildroot

- Can be used to integrate

  - Additional open-source libraries or applications

  - But also your own proprietary libraries and applications \$arrow.r\$
    fully integrated build process

- Each package has its own directory (such as `package/jose`). This
  directory contains:

  - A `Config.in` file (mandatory), describing the configuration options
    for the package. At least one is needed to enable the package. This
    file must be sourced from `package/Config.in`

  - A `jose.mk` file (mandatory), describing how the package is built.

  - A `jose.hash` file (optional, but recommended), containing hashes
    for the files to download, and for the license file.

  - Patches (optional). Each file of the form `*.patch` will be applied
    as a patch.

===  Buildroot: adding a new package, Config.in

package/jose/Config.in

```
config BR2_PACKAGE_JOSE
        bool "jose"
        depends on BR2_TOOLCHAIN_HAS_THREADS
        select BR2_PACKAGE_ZLIB
        select BR2_PACKAGE_JANSSON
        select BR2_PACKAGE_OPENSSL
        help
          C-language implementation of Javascript Object Signing and
          Encryption.

          https://github.com/latchset/jose
```

package/Config.in

```
[...]
source "package/jose/Config.in"
[...]
```

===  Buildroot: adding new package, `.mk` file

package/jose/jose.mk

```
JOSE_VERSION = 11
JOSE_SOURCE = jose-\$(JOSE_VERSION).tar.xz JOSE_SITE = https://github.com/latchset/jose/releases/download/v\$(JOSE_VERSION)
JOSE_LICENSE = Apache-2.0
JOSE_LICENSE_FILES = COPYING
JOSE_INSTALL_STAGING = YES
JOSE_DEPENDENCIES = host-pkgconf zlib jansson openssl

\$(eval \$(meson-package))
```

- The package directory and the prefix of all variables must be
  identical to the suffix of the main configuration option
  `BR2_PACKAGE_JOSE`

- The `meson-package` infrastructure knows how to build #emph[Meson]
  packages. Many other infrastructures exist, for different #emph[build
  systems]

===  Buildroot resources


#table(columns: (50%, 50%), stroke: none, [

- Official site: #link("https://buildroot.org/")

- Buildroot manual:
  #link("https://buildroot.org/downloads/manual/manual.html")

- Complete #emph[Buildroot system development] training course from
  Bootlin

  - #link("https://bootlin.com/training/buildroot/")

  - Freely available training materials

#align(center, [#image("br-site.png", height: 40%)])

#align(center, [#image("br-training.png", height: 40%)])


])

===  Yocto Project / OpenEmbedded


#table(columns: (50%, 50%), stroke: none, [

- OpenEmbedded

  - Started in 2003

  - Goal is to build custom Linux distributions for embedded devices

  - Back then, no stable releases, limited/no documentation, difficult
    to use for products

- Yocto Project

  - Started in 2011

  - By the Linux Foundation

  - Goal is to #emph[industrialize] OpenEmbedded

  - Funds the development of OpenEmbedded, makes regular stable
    releases, QA effort, extensive documentation

  - One Long Term Support release every 2 years, supported for 4 years.

#align(center, [#image("yp-diagram-overview.png", width: 100%)])

])

===  Yocto Project overview

#align(center, [#image("yp-how-it-works-new-diagram.png", width: 100%)])

===  Yocto Project concepts

- Terminology

  - #strong[Layer]: Git repository containing a collection of recipes,
    machines, etc.

  - #strong[Recipe]: metadata that describes how to build a particular
    software component, the contents of an image to generate

  - #strong[Machine]: a specific hardware platform

  - #strong[bitbake]: the orchestration tool that processes
    #emph[recipes] to generate the final products

- Yocto/OpenEmbedded generate a #emph[distribution]

  - For each recipe, it produces one or several binary packages (`deb`,
    `rpm`, `ipk`)

  - A selection of these binary packages are installed to create a
    #emph[root filesystem image] that can be flashed

  - The other packages can be installed at runtime on the system using a
    package management system: `apt`, `dnf`, `opkg`

===  Public layers (1/2)

- Core layers

  - #link("https://git.openembedded.org/bitbake/")[bitbake], not really
    a layer, but the core build orchestration tool

  - #link("https://git.openembedded.org/openembedded-core")[openembedded-core],
    the very core recipes, to build the most common software packages:
    Linux, BusyBox, toolchain, systemd, mesa3d, X.org, Wayland
    bootloaders. Supports only QEMU machines.

  - #link("https://git.yoctoproject.org/poky/")[poky], a layer from the
    Yocto Project that combines #emph[openembedded-core],
    #emph[bitbake], that defines the #emph[Poky] distribution, a
    reference distribution. Supports a few more machines. In practice
    not useful for real projects.

  - #link("http://cgit.openembedded.org/meta-openembedded/")[meta-openembedded],
    community maintained additional recipes from the OpenEmbedded
    project

- BSP layers, provided by HW vendors or the community, to support
  additional hardware platforms: recipes for building custom Linux
  kernel, bootloaders, for HW-related software components

  - #link("https://git.yoctoproject.org/meta-intel/")[meta-intel],
    #link("https://git.yoctoproject.org/meta-arm/")[meta-arm],
    #link("https://git.yoctoproject.org/meta-ti/")[meta-ti],
    #link("https://git.yoctoproject.org/meta-xilinx/")[meta-xilinx],
    #link("https://git.yoctoproject.org/meta-freescale/")[meta-freescale],
    #link("https://github.com/linux4sam/meta-atmel")[meta-atmel],
    #link("https://github.com/STMicroelectronics/meta-st-stm32mp")[meta-st-stm32mp],
    etc.

===  Public layers (2/2)

- Additional software layers: recipes for building additional software
  components, not in #emph[openembedded-core]

  - #link("https://code.qt.io/cgit/yocto/meta-qt6.git/")[meta-qt6],
    #link("https://git.yoctoproject.org/meta-virtualization")[meta-virtualization],
    #link("https://github.com/rauc/meta-rauc")[meta-rauc],
    #link("https://github.com/sbabic/meta-swupdate")[meta-swupdate],
    etc.

- Layer index: #link("https://layers.openembedded.org/")

- Each layer normally has a branch matching the Yocto release you're
  using

- Not all layers have the same level of quality/maintenance: third-party
  layers are not necessarily reviewed by OpenEmbedded experts.

===  Combine layers

- For your project, you will typically combine a number of public layers

  - At least the #emph[openembedded-core] layer

  - Possibly one or several #emph[BSP layers]

  - Possibly one or several additional #emph[software layers]

- And you will create your #emph[own layer], containing recipes for:

  - Machine definitions for your custom hardware platforms

  - Image/distro definitions for your custom system(s)

  - Recipes for your custom software

- A tool is often used to automate the retrieval of the necessary
  layers, at the right version

  - #link("https://gerrit.googlesource.com/git-repo/")[Google repo]
    tool, the Yocto-specific #link("https://kas.readthedocs.io")[Kas]
    utility

===  Yocto quick start: STM32MP1 example

Download #emph[bitbake] and layers

```
  \$\_git clone https://git.openembedded.org/openembedded-core
  \$\_git -C openembedded-core checkout e67d659847af
  \$\_git clone https://git.openembedded.org/meta-openembedded
  \$\_git -C meta-openembedded checkout 4052c97dc83d
  \$\_git clone https://git.openembedded.org/bitbake -b 2.0
  \$\_git clone https://github.com/STMicroelectronics/meta-st-stm32mp.git 
      -b openstlinux-5.15-yocto-kirkstone-mp1-v23.07.26
```

Note: we're not using a tool such as #emph[repo] or #emph[Kas] here, we
are fetching each layer manually.

Enter the build environment

```
\$\_source openembedded-core/oe-init-build-env
```

This automatically enters a directory called `build/`, with a few
files/directories already prepared.

===  Yocto quick start: STM32MP1 example

Configure layers: #emph[conf/bblayers.conf]

```
BBLAYERS ?= " 
  /path/to/openembedded-core/meta 
  /path/to/meta-st-stm32mp 
  /path/to/meta-openembedded/meta-oe 
  /path/to/meta-openembedded/meta-python 
  "
```

Start the build

```
\$\_MACHINE=stm32mp1 bitbake core-image-minimal
```

- `MACHINE=stm32mp1` will build images usable on all STM32MP1 platforms

- `core-image-minimal` builds a minimal image

Build results

```
\$\_ls tmp-glibc/deploy/images/stm32mp1/
```

===  Yocto recipe example

` `#link("https://git.openembedded.org/openembedded-core/tree/meta/recipes-extended/libmnl/libmnl_1.0.5.bb")[`openembedded-core/tree/meta/recipes-extended/libmnl/libmnl_1.0.5.bb`]

```
SUMMARY = "Minimalistic user-space Netlink utility library"
DESCRIPTION = "Minimalistic user-space library oriented to Netlink developers, providing 
    functions for common tasks in parsing, validating, and constructing both the Netlink header and TLVs."
HOMEPAGE = "https://www.netfilter.org/projects/libmnl/index.html"
SECTION = "libs"
LICENSE = "LGPL-2.1-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"

SRC_URI = "https://netfilter.org/projects/libmnl/files/libmnl-\${PV}.tar.bz2"
SRC_URI[sha256sum] = "274b9b919ef3152bfb3da3a13c950dd60d6e2bcd54230ffeca298d03b40d0525"

inherit autotools pkgconfig

BBCLASSEXTEND = "native"
```

- Recipe to build
  #link("https://www.netfilter.org/projects/libmnl/")[libmnl]

- Build system based on #emph[autotools] \$arrow.r\$\_`inherit autotools`

- Available both for the target and the host \$arrow.r\$\_`BBCLASSEXTEND =
  "native"`

===  Yocto resources

- Official website: #link("https://www.yoctoproject.org/")

- Release information: 
  #link("https://wiki.yoctoproject.org/wiki/Releases")

- Official documentation: #link("https://docs.yoctoproject.org/")

  - Maintained by Bootlin engineers!

- Complete #emph[Yocto Project and OpenEmbedded system development]
  training course from Bootlin

  - #link("https://bootlin.com/training/yocto/")

  - Freely available training materials

#align(center, [#image("yp-docs.png", height: 40%)])

#align(center, [#image("yp-training.png", height: 40%)])


===  Buildroot vs. Yocto: a few key differences

- What it builds

  - #strong[Yocto]: builds a distribution, with binary packages and a
    package management system

  - #strong[Buildroot]: builds a fixed functionality root filesystem, no
    binary packages

  - Note: binary packages are not necessarily a good thing for embedded!

- Configuration

  - #strong[Yocto]: flexible, powerful but complex configuration
    description

  - #strong[Buildroot]: very simple configuration system, but sometimes
    limited

- Build strategy

  - #strong[Yocto]: complex and heavy logic, but with efficient caching
    of artifacts and "rebuild only what's needed" features

  - #strong[Buildroot]: simple but somewhat dumb logic, no caching of
    built artifacts, full rebuilds needed for some config changes

- Ecosystem

  - #strong[Yocto]: (relatively) small common base in OpenEmbedded, lots
    of features supported in third party layers \$arrow.r\$\_lots of
    things, but varying quality

  - #strong[Buildroot]: everything in one tree \$arrow.r\$\_perhaps less
    things, but more consistent quality

- Complexity/learning curve

  - #strong[Yocto]: admittedly steep learning curve, #emph[bitbake]
    remains a magic black box for most people

  - #strong[Buildroot]: much smoother and shorter learning curve, the
    tool is simple to approach, and reasonably simple to understand

- And also a matter of personal taste/preference, as often when choosing
  tools

===  OpenWrt

- Another Embedded Linux build system

- Derived from Buildroot a #emph[very] long time ago

  - Now completely different, except for the use of #emph[Kconfig] and
    #emph[make]

- Targeted at building firmware for WiFi routers and other networking
  equipments

- Unlike Buildroot or Yocto that leave a lot of flexibility to the user
  in defining the system architecture, OpenWrt makes a lot of set in
  stone decisions:

  - #emph[musl] is the C library

  - an OpenWrt specific init system

  - an OpenWrt specific inter-process communication bus

  - a Web UI specific to OpenWrt

- The aim of OpenWrt is to build a final product out of the box, with
  support for popular networking products and development boards

- `https://openwrt.org/`

== Working with distributions
<working-with-distributions>
===  Binary distributions

- Many popular Linux desktop/server distributions have support for
  embedded architectures

  - #link("https://www.debian.org")[Debian]: ARMv5, ARMv7, ARM64, i386,
    x86-64, MIPS, PowerPC, RISC-V in progress

  - #link("https://www.ubuntu.com")[Ubuntu]: ARMv7, ARM64, x86-64,
    RISC-V (initial support), PowerPC64 little-endian

  - #link("https://getfedora.org")[Fedora]: ARMv7, ARM64, x86-64, MIPS
    little-endian, PowerPC64 little-endian, RISC-V

- Some more specialized Linux distributions as well

  - #link("https://www.raspberrypi.com/software/")[Raspberry Pi OS], a
    Debian derivative targeted at RaspberryPi platforms

  - #link("https://www.alpinelinux.org/")[Alpine Linux], a lightweight
    distribution, based on #emph[musl] and #emph[Busybox], ARMv7, ARM64,
    i386, x86-64, PowerPC64 little-endian

===  Binary distributions pitfalls

- Be careful when using a binary distribution on how you create your
  system image, and how reproducible this process is

- We have seen projects use the following (bad) procedure:

  - Install a binary distribution manually on their target hardware

  - Install all necessary packages by hand

  - Compile the final applications on the target

  - Tweak configuration files directly on the target

  - Then duplicate the resulting SD card for all other boards

- This process is really bad as:

  - it is not reproducible

  - it requires installing many more things on the target than needed
    (development tools), increasing the footprint, the attack surface
    and the maintenance effort

- If you end up using a binary distribution in production, make sure you
  have an automated and reproducible process to generate the complete
  image, ready to flash on your target.

===  Debian/Ubuntu image building tools


#table(columns: (50%, 50%), stroke: none, [ ELBE

- #strong[E.]mbedded #strong[L.]inux #strong[B.]uild
  #strong[E.]nvironment

- Implemented in Python

- Uses an XML file as input to describe the system to generate

- Can use pre-built packages from Debian/Ubuntu repositories, but can
  also cross-compile and install additional packages

- #link("https://elbe-rfs.org/")

- #link("https://www.youtube.com/watch?v=BwHzyCGB7As")[Building Embedded Debian and Ubuntu Systems with ELBE]
  talk

- #link("https://bootlin.com/blog/elbe-automated-building-of-ubuntu-images-for-a-raspberry-pi-3b/")[ELBE: automated building of Ubuntu images for a Raspberry Pi 3B]

DebOS

- Debian OS images builder

- Implemented in Go

- Uses a YAML file as input to describe the system to generate

- #link("https://www.youtube.com/watch?v=_NZrSR3prwk")[Creating Debian-Based Embedded Systems in the Cloud Using Debos]
  talk

- #link("https://github.com/go-debos/debos")


])

===  Android

- The obviously highly popular mobile operating system

- Uses the Linux kernel

- Most of the user-space is completely different from a normal embedded
  Linux system

  - Most components rewritten by Google

  - #emph[bionic] C library

  - Custom #emph[init] system and device management

  - Custom IPC mechanism, custom display stack, custom multimedia stack

  - Custom build system

- Android pitfalls for industrial embedded systems

  - Large footprint, and resource hungry

  - Complexity and build time

  - Maintenance issues: difficult to upgrade to newer releases due to
    increasing hardware requirements

- #link("https://www.opersys.com/training/embedded-android-training/")[Embedded Android Training]
  course from #link("https://www.opersys.com")[Opersys], with freely
  available training materials

===  Automotive Grade Linux, Tizen

- Industry groups collaborate around the creation of embedded Linux
  distributions targeting specific markets

  - These are regular embedded Linux systems, usually based on Yocto,
    with a selection of relevant open-source software components

  - Fund the development of missing features in existing components, or
    development of new software components

- Automotive Grade Linux

  - Linux Foundation project

  - #emph[Collaborative open source project that is bringing together
    automakers, suppliers and technology companies to accelerate the
    development and adoption of a fully open software stack for the
    connected car]

  - #link("https://www.automotivelinux.org/")

- Tizen

  - Linux Foundation project too

  - Operating system targeting TVs, wearables, phones, in-vehicle
    infotainment, based on HTML5 applications.

  - #link("https://www.tizen.org/")

#setuplabframe([System build with Buildroot],[ Time to start the
practical lab!

- Using Buildroot to rebuild the same basic system plus a sound playing
  server (#emph[MPD]) and a client to control it (#emph[mpc]).

- Overlaying the root filesystem built by Buildroot

- Driving music playback, directly from the target, and then remotely
  through an MPD client on the host machine.

- Analyzing dependencies between packages.

- Building #emph[evtest] and using it to test the Nunchuk device driver.

])