#import "/common/embedded-linux-vars.typ": *

#let imx93-frdm-nunchuk = false 
#let imx93-frdm-nunchuk = false 

#if training == "yocto" {[#let imx93-frdm-nunchuk = true ]}

#if training== "embedded-linux" {[#let imx93-frdm-nunchuk = true ]}

#if training== "linux-kernel"{[#let imx93-frdm-nunchuk = true]}

#let imx93-frdm-audio = false 
#let imx93-frdm-audio = false 

#if training == "embedded-linux" {[#let imx93-frdm-audio = true]}

#let imx93-frdm-extra-serial 
#let imx93-frdm-extra-serial = false 

#if training == "linux-kernel" {[#let imx93-frdm-extra-serial = true]}


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

===  IMX93 FRDM shopping list
#table(columns: (50%, 50%), stroke: none,[
NXP i.MX93 11x11 FRDM board Available from Mouser (76 EUR + VAT)

- NXP i.MX 93 (Dual ARM Cortex-A55 + Cortex-M33)

- 2 GB LPDDR4

- 32 GB of on-board eMMC storage

- Plenty of peripherals: I2C, SPI, UART, USB...

2 USB-C cable for the power supply and the serial console

RJ45 cable for networking

#if imx93-frdm-extra-serial{[

USB Serial Cable - 3.3 V - Female ends (for serial labs, two if
possible)
#footnote[#link("https://www.olimex.com/Products/USB-Modules/Interfaces/USB-SERIAL-F")]]}

#if imx93-frdm-nunchuk{[

Nintendo Nunchuk with UEXT connector
#footnote[#link("https://www.olimex.com/Products/Modules/Sensors/MOD-WII/MOD-Wii-UEXT-NUNCHUCK/")]

Breadboard jumper wires - Male/Female ends (to connect the Nunchuk)
#footnote[#link("https://www.olimex.com/Products/Breadboarding/JUMPER-WIRES/JW-200x10-FM/")]]}

RJ45 cable for networking

#if imx93-frdm-audio{[

A standard USB audio headset]}

],[
#align(center, [#image("imx93-frdm.png", width: 100%)])

#if imx93-frdm-extra-serial{[
#align(center, [#image("usb-serial-cable-female.png", height: 200%)]) ]}

#if imx93-frdm-nunchuk{[
#align(center, [#image("nunchuk.jpg", height: 250%)]) 
#align(center, [#image("jumper-wires.jpg", height: 150%)]) ]}

#if imx93-frdm-audio {[#align(center, [#image("usb-audio.png", width: 60%)]) ]}

])
