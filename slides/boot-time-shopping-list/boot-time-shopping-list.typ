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

===  Shopping list: hardware for this course
#table(
columns: (70%, 30%), stroke: none, gutter: 12pt,
[
- BeagleBone Black or BeagleBone Black Wireless - Multiple distributors:
  
  See #link("https://www.beagleboard.org/boards").

- 5V power supply, at least 2A, for the BeagleBone Black, with a 5.5 mm
  barrel jack connector. Needed to drive the LCD cape! 
  #link("https://www.olimex.com/Products/Power/SY1005E/")

- USB Serial Cable - 3.3 V - Female ends (for serial console): 
  #link("https://www.olimex.com/Products/USB-Modules/Interfaces/USB-SERIAL-F")

- Beagle Bone Black LCD4.3 cape from 4D systems 
  #link("https://4dsystems.com.au/products/4dcape-43/")

- A standard micro SD card - 1 GB or more

- A faster micro SD card - 1 GB or more

],[
#align(center, [#image("../../common/usb-serial-cable-female.png", height: 20%)]) 
#align(center, [#image("../../common/sd-card.pdf", height: 20%)]) 

]
)