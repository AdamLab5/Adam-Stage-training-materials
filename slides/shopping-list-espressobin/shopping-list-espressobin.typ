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

===  Shopping list


#table(columns: (50%, 50%), stroke: none, [

- EspressoBin board: one of
  #link("https://globalscaletechnologies.com/product/espressobin/")[ESPRESSObin 1GB DDR4 with micro SD Card Slot],
  #link("https://globalscaletechnologies.com/product/espressobin-1gb-ddr4-with-4gb-emmc/")[ESPRESSObin 1GB DDR4 with 4GB eMMC]
  or
  #link("https://globalscaletechnologies.com/product/espressobin-2gb-msd-card-slot/")[ESPRESSObin 2GB DDR4 with micro SD Card Slot]

  - Marvell Armada 3720 SoC (Dual ARM64 Cortex-A53 CPU)

  - SoC with powerful Network Controller (up to 2.5Gbps), SATA, PCIe

  - 1 or 2 GB of RAM

  - Versions with SD card or eMMC

  - Marvell 88e6341 Switch with 3 Gbps interfaces

- A 12V power supply compatible with the EspressoBin, such as
  #link("https://www.amazon.fr/dp/B015MGWBYE")[this one] (5.5mm / 2.1mm)

- A USB-A to micro B cable for the serial console.

- Two RJ45 cables for networking

- A microSD card of at least 8 GB capacity

],[

#align(center, [#image("espressobin.jpg", height: 20%)])

])
