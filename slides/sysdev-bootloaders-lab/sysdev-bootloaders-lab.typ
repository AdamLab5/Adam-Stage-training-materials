#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "/typst/local/themeBootlin.typ": *

#import "/typst/local/common.typ": *

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

#setuplabframe([U-Boot / TF-A],[ Time to start the practical lab!#v(0.3em)

- Communicate with the board using a serial console#v(0.3em)

- Configure, build and install the bootloader stages:

  - #emph[TF-A] and #emph[U-Boot] on STM32MP1 and Beagleplay

  - #emph[U-Boot SPL] and #emph[U-Boot] on BeagleBoneBlack and QEMU#v(0.3em)

- Learn #emph[U-Boot] commands#v(0.3em)

- Set up #emph[TFTP] communication with the host

])
