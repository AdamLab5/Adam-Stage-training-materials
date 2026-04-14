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

== Contents

===  Root filesystem organization

- The organization of a Linux root filesystem in terms of directories is
  well-defined by the #strong[Filesystem Hierarchy Standard]

- #link("https://refspecs.linuxfoundation.org/fhs.shtml")

- Most Linux systems conform to this specification

  - Applications expect this organization

  - It makes it easier for developers and users as the filesystem
    organization is similar in all systems

===  Important directories (1)

/ /bin: #block[
Basic programs
])

/ /boot: #block[
Kernel images, configurations and initramfs (only when the kernel is
loaded from a filesystem, not common on non-x86 architectures)
])

/ /dev: #block[
Device files (covered later)
])

/ /etc: #block[
System-wide configuration
])

/ /home: #block[
Directory for the users home directories
])

/ /lib: #block[
Basic libraries
])

/ /media: #block[
Mount points for removable media
])

/ /mnt: #block[
Mount point for a temporarily mounted filesystem
])

/ /proc: #block[
Mount point for the proc virtual filesystem
])

===  Important directories (2)

/ /root: #block[
Home directory of the `root` user
])

/ /run: #block[
Run-time variable data (previously `/var/run`)
])

/ /sbin: #block[
Basic system programs
])

/ /sys: #block[
Mount point of the sysfs virtual filesystem
])

/ /tmp: #block[
Temporary files
])

/ /usr: #block[
/ /usr/bin: #block[
Non-basic programs
])

/ /usr/lib: #block[
Non-basic libraries
])

/ /usr/sbin: #block[
Non-basic system programs
])
])

/ /var: #block[
Variable data files, for system services. This includes spool
directories and files, administrative and logging data, and transient
and temporary files
])

===  Separation of programs and libraries

- Basic programs are installed in `/bin` and `/sbin` and basic libraries
  in `/lib`

- All other programs are installed in `/usr/bin` and `/usr/sbin` and all
  other libraries in `/usr/lib`

- In the past, on UNIX systems, `/usr` was very often mounted over the
  network, through NFS

- In order to allow the system to boot when the network was down, some
  binaries and libraries are stored in `/bin`, `/sbin` and `/lib`

- `/bin` and `/sbin` contain programs like `ls`, `ip`, `cp`, `bash`,
  etc.

- `/lib` contains the C library and sometimes a few other basic
  libraries

- All other programs and libraries are in `/usr`

- Update: distributions are now making `/bin` link to `/usr/bin`, `/lib`
  to `/usr/lib` and `/sbin` to `/usr/sbin`. Details on
  #link("https://systemd.io/THE_CASE_FOR_THE_USR_MERGE/")[https://systemd.io/THE_CASE_FOR_THE_USR_MERGE/].
