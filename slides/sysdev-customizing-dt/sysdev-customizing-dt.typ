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

===  Customize your board device tree!

- Kernel developers write #emph[Device Tree Sources (DTS)], which become
  #emph[Device Tree Blobs (DTB)] once compiled.

- There is one different Device Tree for each board/platform supported
  by the kernel, available in
  `arch/<arch>/boot/dts/<vendor>/<board>.dtb`
  (`arch/arm/boot/dts/<board>.dtb` on ARM 32 before Linux 6.5).

- As a board user, you may have legitimate needs to customize your board
  device tree:

  - To describe external devices attached to non-discoverable busses and
    configure them.

  - To configure pin muxing: choosing what SoC signals are made
    available on the board external connectors. See
    #link("http://linux.tanzilli.com/") for a web service doing this
    interactively.

  - To configure some system parameters: flash partitions, kernel
    command line (other ways exist)
