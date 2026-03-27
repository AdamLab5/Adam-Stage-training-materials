#import "@local/bootlin:0.1.0": *
#import "@local/bootlin-yocto:0.1.0": *
#import "@local/bootlin-utils:0.1.0": *
#import "../../typst/local/themeBootlin.typ": *
#import "../../typst/local/common.typ": *
#show: bootlin-theme.with(
  aspect-ratio: "16-9",

config-common(
  // Compile with `typst c --input handout=1 ...` to generate the handout.
  handout: "handout" in sys.inputs and sys.inputs.handout == "1",
))
#show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius:0.5em, width:100%)
#show raw.where(block: false): r => { text(fill: color-link)[#r] } 

===  The full system

#columns(gutter: 8pt)[

- Beagle Bone Black board (of course). The Wireless variant should work
  fine too.

- Beagle Bone Black 4.3" LCD cape from 4D Systems (not the one shown on
  this picture) 
  #link("https://4dsystems.com.au/products/4dcape-43/")

- Standard USB webcam (supported through the ``` uvcvideo ``` driver).

#colbreak() #align(center, [#image("../../common/beaglecam.jpg", width: 100%)]) 
]
