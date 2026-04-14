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

== Pseudo Filesystems ===  proc virtual filesystem

- The `proc` virtual filesystem exists since the beginning of Linux

- It allows

  - The kernel to expose statistics about running processes in the
    system

  - The user to adjust at runtime various system parameters about
    process management, memory management, etc.

- The `proc` filesystem is used by many standard user space
  applications, and they expect it to be mounted in `/proc`

- Applications such as `ps` or `top` would not work without the `proc`
  filesystem

- Command to mount `proc`: 
  `mount -t proc nodev /proc`

- See #kdochtml("filesystems/proc") in kernel documentation or `man
  proc`

===  proc contents

- One directory for each running process in the system

  - `/proc/<pid>`

  - `cat /proc/3840/cmdline`

  - It contains details about the files opened by the process, the CPU
    and memory usage, etc.

- `/proc/interrupts`, `/proc/iomem`, `/proc/cpuinfo` contain general
  device-related information

- `/proc/cmdline` contains the kernel command line

- `/proc/sys` contains many files that can be written to adjust kernel
  parameters

  - They are called #emph[sysctl]. See
    #kdochtmldir("admin-guide/sysctl") in kernel documentation.

  - Example (free the page cache and slab objects): 
    `echo 3 > /proc/sys/vm/drop_caches`

===  sysfs filesystem

- It allows to represent in user space the vision that the kernel has of
  the buses, devices and drivers in the system

- It is useful for various user space applications that need to list and
  query the available hardware, for example `udev` or `mdev` (see later)

- All applications using sysfs expect it to be mounted in the `/sys`
  directory

- Command to mount `/sys`: 
  `mount -t sysfs nodev /sys`

- ```
  \$\_ls /sys/
  block bus class dev devices firmware fs kernel module power
  ```
