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

== Linux kernel sources

===  Location of official kernel sources

- The mainline versions of the Linux kernel, as released by Torvalds

  - These versions follow the development model of the kernel (`master`
    branch)

  - They may not contain the latest developments from a specific area
    yet

  - A good pick for products development phase

  - #link("https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git")

- The stable versions of the Linux kernel, as maintained by a
  maintainers group

  - These versions do not bring new features compared to Linus` tree

  - Only bug fixes and security fixes are pulled there

  - Each version is stabilized during the development period of the next
    mainline kernel

  - Certain versions can be maintained for much longer, 2\$plus\$\_years

  - A good pick for products commercialization phase

  - #link("https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git")

===  Location of non-official kernel sources

- Many chip vendors supply their own kernel sources

  - Focusing on hardware support first

  - Can have a very important delta with mainline Linux

  - Sometimes they break support for other platforms/devices without
    caring

  - Useful in early phases only when mainline hasn`t caught up yet (many
    vendors invest in the mainline kernel at the same time)

  - Suitable for PoC, not suitable for products on the long term as
    usually no updates are provided to these kernels

  - Getting stuck with a deprecated system with broken software that
    cannot be updated has a real cost in the end

- Many kernel sub-communities maintain their own kernel, with usually
  newer but fewer stable features, only for cutting-edge development

  - Architecture communities (ARM, MIPS, PowerPC, etc)

  - Device drivers communities (I2C, SPI, USB, PCI, network, etc)

  - Other communities (real-time, etc)

  - Not suitable to be used in products

===  Getting Linux sources

- The kernel sources are available from
  #link("https://kernel.org/pub/linux/kernel") as #strong[full tarballs]
  (complete kernel sources) and #strong[patches] (differences between
  two kernel versions).

- But today the entire open source community has settled in favor of Git

  - Fast, efficient with huge code bases, reliable, open source

  - Incidentally written by Torvalds

===  Going through Linux sources
