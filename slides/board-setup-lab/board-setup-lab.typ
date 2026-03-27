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

Prepare your board

- Access the board through its serial line

- Check the stock bootloader

- Attach the 4.3" LCD cape
