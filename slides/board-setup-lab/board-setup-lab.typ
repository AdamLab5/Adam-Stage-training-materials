#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "typst/local/themeBootlin.typ": *

#import "typst/local/common.typ": *

#show: bootlin-theme.with( aspect-ratio: "16-9", config-common(
handout: "handout" in sys.inputs and sys.inputs.handout == "1", ))

#show raw.where(block: true): set block(fill: luma(240), inset: 1em,
radius:0.5em, width:100%)

#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): r => {

set block(fill: luma(240), inset: 0.4em, radius: 0.5em, width: 95%,
breakable: true, above: 12pt, below: 12pt)

set text(11pt)

r

}

#show raw.where(lang: "console", block: true): r => {

set block(fill: luma(240), inset: 0.4em, radius: 0.5em, width: 95%,
breakable: true, above: 6pt)

set text(9pt)

r

}

#setuplabframe([Board setup],[ Prepare your board

- Access the board through its serial line

- Check the stock bootloader

- Attach the 4.3" LCD cape

])
