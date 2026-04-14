#import "common/embedded-linux-vars.typ": *
#let beaglebone-nunchuk = false
#let beaglebone-nunchuk = false 
#if training == "yocto" {[
#let beaglebone-nunchuk = true ]}
#if training== "buildroot" {[
#let beaglebone-nunchuk = true ]}
#if training=="embedded-linux" {[
#let beaglebone-nunchuk = true ]}
#if training =="linux-kernel" {[
#let beaglebone-nunchuk = true]}

#let beaglebone-audio = false 
#let beaglebone-audio = false 
#if training == "embedded-linux" {[
#let beaglebone-audio = true]}

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

===  Beaglebone Black / Beaglebone black wireless shopping list


#table(columns: (50%, 50%), stroke: none,[

#align(center, [#image("beagleboneblack.png", width: 60%)])

#align(center, [#image("common/usb-serial-cable-female.jpg", width: 60%)]) 
#if beaglebone-nunchuk {[#align(center, [#image("nunchuk.jpg", width: 60%)]) ]}
#align(center, [#image("common/jumper-wires.jpg", width: 60%)]) 

#if beaglebone-audio {[#align(center, [#image("usb-audio.png", width: 60%)]) ]}

])
