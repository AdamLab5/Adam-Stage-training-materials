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

= Introduction to Embedded Linux

===  Birth of Free Software


#table(columns: (50%, 50%), stroke: none, [

- 1983, Richard Stallman, #strong[GNU project] and the #strong[free
  software] concept. Beginning of the development of #emph[gcc],
  #emph[gdb], #emph[glibc] and other important tools

- 1991, Linus Torvalds, #strong[Linux kernel project], a UNIX-like
  operating system kernel. Together with GNU software and many other
  open-source components: a completely free operating system, GNU/Linux

-  1995, Linux is more and more popular on server systems

-  2000, Linux is more and more popular on #strong[embedded systems]

-  2008, Linux is more and more popular on mobile devices and phones

-  2012, Linux is available on cheap, extensible hardware: Raspberry Pi,
  BeagleBone Black

#align(center, [#image("richard-stallman.jpg", width: 100%)])
Richard Stallman in 2019 
#link("https://commons.wikimedia.org/wiki/File:Richard_Stallman_at_LibrePlanet_2019.jpg")[https://commons.wikimedia.org/wiki/File:Richard_Stallman_at_LibrePlanet_2019.jpg]

])

===  Free software?

- A program is considered #strong[free] when its license offers to all
  its users the following #strong[four] freedoms

  - Freedom to run the software for any purpose

  - Freedom to study the software and to change it

  - Freedom to redistribute copies

  - Freedom to distribute copies of modified versions

- These freedoms are granted for both commercial and non-commercial use

- They imply the availability of source code, software can be modified
  and distributed to customers

- #strong[Good match for embedded systems!]

===  What is embedded Linux?

Embedded Linux is the usage of the #strong[Linux kernel] and various
#strong[open-source] components in embedded systems

===  Advantages of Linux and Open-Source in embedded systems


#table(columns: (50%, 50%), stroke: none, [

- #strong[Ability to reuse components] 
  Many features, protocols and hardware are supported. Allows to focus
  on the added value of your product.

- #strong[Low cost] 
  No per-unit royalties. Development tools free too. But of course
  deploying Linux costs time and effort.

- #strong[Full control] 
  You decide when to update components in your system. No vendor
  lock-in. This secures your investment.

- #strong[Easy testing of new features] 
  No need to negotiate with third-party vendors. Just explore new
  solutions released by the community.

- #strong[Quality] 
  Your system is built on high-quality foundations (kernel, compiler,
  C-library, base utilities...). Many Open-Source applications have good
  quality too.

- #strong[Security] 
  You can trace the sources of all system components and perform
  independent vulnerability assessments.

- #strong[Community support] 
  Can get very good support from the community if you approach it with a
  constructive attitude.

- #strong[Participation in community work] 
  Possibility to collaborate with peers and get opportunities beyond
  corporate barriers.


])

== A few examples of embedded systems running Linux
<a-few-examples-of-embedded-systems-running-linux>
===  Wireless routers

#align(center, [#image("linksys-wireless-router.jpg", height: 80%)])

Image credits: Evan Amos (#link("https://bit.ly/2JzDIkv"))

===  Video systems

#align(center, [#image("chromecast-2015.jpg", height: 80%)])

Image credits: #link("https://bit.ly/2HbwyVq")

===  Bike computers

#align(center, [#image("bike-computer.jpg", height: 80%)])

Product from BLOKS Permission to use this picture only in this document,
in updates and in translations.

===  Robots

#align(center, [#image("beagle-robot.jpg", height: 750%)])

eduMIP robot (#link("https://www.ucsdrobotics.org/edumip"))

===  In space


#table(columns: (50%, 50%), stroke: none, [ SpaceX Starlink satellites

#align(center, [#image("starlink.jpg", height: 30%)]) 
SpaceX Falcon 9 and Falcon Heavy rockets 
#align(center, [#image("falcon-heavy.jpg", height: 30%)]) 
Image credits: Wikipedia Mars Ingenuity Helicopter 
#align(center, [#image("mars-helicopter.jpg", height: 30%)])

#align(center, [#image("mars-helicopter-video.jpg", height: 30%)])

See the #emph[Linux on Mars: How the Perseverance Rover and Ingenuity
Helicopter Leveraged Linux to Accomplish their Mission] presentation
from Tim Canham (JPL, NASA):
#link("https://youtu.be/0_GfMcBmbCg?t=111")[https://youtu.be/0_GfMcBmbCg?t=111]

])

== Embedded hardware for Linux systems
<embedded-hardware-for-linux-systems>
===  Processor and architecture (1) The Linux kernel and most other
architecture-dependent components support a wide range of 32 and 64 bit
architectures

- x86 and x86-64, as found on PC platforms, but also embedded systems
  (multimedia, industrial)

- ARM, with hundreds of different #emph[System on Chip]s 
  (#emph[SoC]: CPU + on-chip devices, for all sorts of products)

- RISC-V, the rising architecture with a free instruction set 
  (from high-end cloud computing to the smallest embedded systems)

- PowerPC (mainly real-time, industrial applications)

- MIPS (mainly networking applications)

- Microblaze (Xilinx), Nios II (Altera): soft cores on FPGAs

- Others: ARC, m68k, Xtensa, SuperH...

===  Processor and architecture (2)

- Both MMU and no-MMU architectures are supported, even though no-MMU
  architectures have a few limitations.

- Linux does not support small microcontrollers (8 or 16 bit)

- Besides the toolchain, the bootloader and the kernel, all other
  components are generally #strong[architecture-independent]

===  RAM and storage

- #strong[RAM]: a very basic Linux system can work within 8 MB of RAM,
  but a more realistic system will usually require at least 32 MB of
  RAM. Depends on the type and size of applications.

- #strong[Storage]: a very basic Linux system can work within 4 MB of
  storage, but usually more is needed.

  - #strong[Block storage]: SD/MMC/eMMC, USB mass storage, SATA, etc,

  - #strong[Raw flash storage] is supported too, both NAND and NOR
    flash, with specific filesystems

- Not necessarily interesting to be too restrictive on the amount of
  RAM/storage: having flexibility at this level allows to increase
  performance and re-use as many existing components as possible.

===  Communication

- The Linux kernel has support for many common communication buses

  - I2C

  - SPI

  - 1-wire

  - SDIO

  - PCI

  - USB

  - CAN (mainly used in automotive)

- And also extensive networking support

  - Ethernet, Wifi, Bluetooth, CAN, etc.

  - IPv4, IPv6, TCP, UDP, etc.

  - Firewalling, advanced routing, multicast

===  Types of hardware platforms (1)


#table(columns: (50%, 50%), stroke: none, [

- #strong[Evaluation platforms] from the SoC vendor. Usually expensive,
  but many peripherals are built-in. Generally unsuitable for real
  products, but best for product development.

- #strong[System on Module] (SoM) or #strong[Component on Module], a
  small board with only CPU/RAM/flash and a few other core components,
  with connectors to access all other peripherals. Can be used to build
  end products for small to medium quantities.

#align(center, [#image("stm32mp157c-ev1.png", width: 100%)])
STM32MP157C-EV1 evaluation board 
#link("https://www.mouser.fr/ProductDetail/STMicroelectronics/STM32MP157C-EV1?qs=9r4v7xj2LnmHBJ35TLmsRg%3D%3D")[Image credits]
#align(center, [#image("pocketbeagle.png", width: 100%)])
PocketBeagle 
Image credits (Beagleboard.org): 
#link("https://beagleboard.org/pocket") 
])

===  Types of hardware platforms (2)


#table(columns: (50%, 50%), stroke: none, [

- #strong[Community development platforms], to make a particular SoC
  popular and easily available. These are ready-to-use and low cost, but
  usually have fewer peripherals than evaluation platforms. To some
  extent, can also be used for real products.

- #strong[Custom platform]. Schematics for evaluation boards or
  development platforms are more and more commonly freely available,
  making it easier to develop custom platforms.

#align(center, [#image("../shopping-list-beaglebone/beagleboneblack.png", height: 30%)])
Beaglebone Black Wireless board 
#align(center, [#image("teres-pcb1-a64.jpg", height: 30%)])
Olimex Open hardware ARM laptop main board 
Image credits (Olimex): 
#link("https://www.olimex.com/Products/DIY-Laptop/") 
])

===  Criteria for choosing the hardware

- Most SoCs are delivered with support for the Linux kernel and for an
  open-source bootloader.

- Having support for your SoC in the official versions of the projects
  (kernel, bootloader) is a lot better: quality is better, new versions
  are available, and Long Term Support releases are available.

- Some SoC vendors and/or board vendors do not contribute their changes
  back to the mainline Linux kernel. Ask them to do so, or use another
  product if you can. A good measurement is to see the delta between
  their kernel and the official one.

- #strong[Between properly supported hardware in the official Linux
  kernel and poorly-supported hardware, there will be huge differences
  in development time and cost.]

== Embedded Linux system architecture
<embedded-linux-system-architecture>
===  Host and target

#align(center, [#image("host-and-target.pdf", height: 80%)])

===  Software components

- Cross-compilation toolchain

  - Compiler that runs on the development machine, but generates code
    for the target

- Bootloader

  - Started by the hardware, responsible for basic initialization,
    loading and executing the kernel

- Linux Kernel

  - Contains the process and memory management, network stack, device
    drivers and provides services to user space applications

- C library

  - Of course, a library of C functions

  - Also the interface between the kernel and the user space
    applications

- Libraries and applications

  - Third-party or in-house

===  Embedded Linux work

Several distinct tasks are needed when deploying embedded Linux in a
product:

- #strong[Board Support Package development]

  - A BSP contains a bootloader and kernel with the suitable device
    drivers for the targeted hardware

  - Purpose of our
    #link("https://bootlin.com/training/kernel")[#emph[Kernel Development course]]

- #strong[System integration]

  - Integrate all the components, bootloader, kernel, third-party
    libraries and applications and in-house applications into a working
    system

  - Purpose of #emph[this] course

- #strong[Development of applications]

  - Normal Linux applications, but using specifically chosen libraries
