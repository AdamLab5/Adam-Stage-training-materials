#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "../../typst/local/themeBootlin.typ": *

#import "../../typst/local/common.typ": *

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

== Minimal filesystem ===  Basic applications

- In order to work, a Linux system needs at least a few applications

- An `init` application, which is the first user space application
  started by the kernel after mounting the root filesystem (see
  #link("https://en.wikipedia.org/wiki/Init")):

  - The kernel tries to run the command specified by the `init=`
    command line parameter if available.

  - Otherwise, it tries to run `/sbin/init`, `/etc/init`, `/bin/init`
    and `/bin/sh`.

  - In the case of an initramfs, it will only look for `/init`. Another
    path can be supplied by the `rdinit=` kernel argument.

  - If none of this works, the kernel panics and the boot process is
    stopped.

  - The `init` application is responsible for starting all other user
    space applications and services, and for acting as a universal
    parent for processes whose parent terminate before they do.

- A shell, to implement scripts, automate tasks, and allow a user to
  interact with the system

- Basic UNIX executables, for use in system scripts or in interactive
  shells: `mv`, `cp`, `mkdir`, `cat`, `modprobe`, `mount`, `ip`, etc.

- These basic components have to be integrated into the root filesystem
  to make it usable

===  Overall booting process

#align(center, [#image("overall-boot-sequence.pdf", height: 80%)])
