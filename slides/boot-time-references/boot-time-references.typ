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

= References

===  Conference presentations

- Andrew Murray - The Right Approach to Minimal Boot Time (2010,
  #link("https://bootlin.com/pub/video/2010/elce/elce2010-murray-boot-time.webm")[video],
  #link("https://elinux.org/images/f/f7/RightApproachMinimalBootTimes.pdf")[slides])
  
  Great talk about the methodology.

- Chris Simmonds - A Pragmatic Guide to Boot-Time Optimization (2017,
  #link("https://youtu.be/gIK1he6Ocpg")[video],
  #link("https://elinux.org/images/6/64/Chris-simmonds-boot-time-elce-2017_0.pdf")[slides])

- Jan Altenberg - How to Boot Linux in One Second (2015,
  #link("https://www.elinux.org/images/9/97/Boot_one_second_altenberg.pdf")[slides])

- Michael Opdenacker - U-Boot Falcon Mode and Adding Support for New
  Boards (2021) 
  Video: #link("https://youtu.be/okY9fBEuaoM") - Corresponding to the
  Falcon Mode section in this document.

- Elinux.org - Boot-time resources 
  #link("https://elinux.org/Boot_Time")[https://elinux.org/Boot_Time]
