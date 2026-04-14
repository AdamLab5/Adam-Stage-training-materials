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

===  Booting with U-Boot

- On ARM32, U-Boot can boot `zImage` (`bootz` command)

- On ARM64 or RISC-V, it boots the `Image` file (`booti` command)

- In addition to the kernel image, U-Boot should also pass a DTB to the
  kernel.

- The typical boot process is therefore:

  + Load `zImage` at address X in memory

  + Load `<board>.dtb` at address Y in memory

  + Start the kernel with `boot[z|i] X - Y` 
    The `-` in the middle indicates no #emph[initramfs]

===  Kernel command line

- In addition to the compile time configuration, the kernel behavior can
  be adjusted with no recompilation using the #strong[kernel command
  line]

- The kernel command line is a string that defines various arguments to
  the kernel

  - It is very important for system configuration

  - `root=` for the root filesystem (covered later)

  - `console=` for the destination of kernel messages

  - Example: `console=ttyS0 root=/dev/mmcblk0p2 rootwait`

  - Many more exist. The most important ones are documented in
    #kdochtml("admin-guide/kernel-parameters") in kernel
    documentation.

===  Passing the kernel command line


#table(columns: (50%, 50%), stroke: none, [

- U-Boot carries the Linux kernel command line string in its `bootargs`
  environment variable

- Right before starting the kernel, it will store the contents of
  `bootargs` in the `chosen` section of the Device Tree

- The kernel will behave differently depending on its configuration:

  - If #kconfig("CONFIG_CMDLINE_FROM_BOOTLOADER") is set: 
    The kernel will use only the string from the bootloader

  - If #kconfig("CONFIG_CMDLINE_FORCE") is set: 
    The kernel will only use the string received at configuration time
    in #kconfig("CONFIG_CMDLINE")

  - If #kconfig("CONFIG_CMDLINE_EXTEND") is set: 
    The kernel will concatenate both strings

See the "Understanding U-Boot Falcon Mode" presentation from Michael
Opdenacker, for details about how U-Boot boots Linux. 
#align(center, [#image("understanding-falcon-mode-presentation.png", width: 100%)])

Slides: #link("https://bootlin.com/pub/conferences/2021/lee/") 
Video:
#link("https://www.youtube.com/watch?v=LFe3x2QMhSo")[https://www.youtube.com/watch?v=LFe3x2QMhSo]

])

===  Kernel log

- The kernel keeps its messages in a circular buffer in memory

  - The size is configurable using
    #kconfig("CONFIG_LOG_BUF_SHIFT")

- When a module is loaded, related information is available in the
  kernel log.

- Kernel log messages are available through the `dmesg` command
  (#strong[d]iagnostic #strong[mes]sa#strong[g]e)

- Kernel log messages are also displayed on the console pointed by the
  `console=` kernel command line argument

  - Console messages can be filtered by level using the `loglevel`
    parameter

  - Example: `console=ttyS0 loglevel=5`

- It is possible to write to the kernel log from user space: `echo
  "<n>Debug info" > /dev/kmsg`
