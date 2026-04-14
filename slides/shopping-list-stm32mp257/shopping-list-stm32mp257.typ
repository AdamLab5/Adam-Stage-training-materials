#import "common/embedded-linux-vars.typ": *

#let stm32mp257-nunchuk = false 
#if training == "yocto" {
  [#let stm32mp257-nunchuk = true]} 
#if training == "buildroot"{ 
[#let stm32mp257-nunchuk = true]
}
#if training == "embedded-linux" {
[#let stm32mp257-nunchuk = true ]
}
#if training == "linux-kernel" {
[#let stm32mp257-nunchuk = true]
}
#let stm32mp257-audio = false
#if training == "embedded-linux"{
[#let stm32mp257-audio = true]
}
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

===  STM32MP257 shopping list


#table(columns: (50%, 50%), stroke: none, [

Discovery Kits STM32MP257F from STMicroelectronics #footnote[Boards
documentation:
#link("https://www.st.com/en/evaluation-tools/stm32mp257f-dk.html")]

- STM32MP257 (Dual Cortex-A35 + Cortex-M33) CPU

- 4GB LPDDR4 RAM

- Plenty of periperals: GPIOs, SPI, Serial, USB, ethernet...

USB-C to USB-A cable (to power the board and access console)

#if stm32mp257-nunchuk {[

Nintendo Nunchuk with UEXT connector]}
#footnote[#link("https://www.olimex.com/Products/Modules/Sensors/MOD-WII/MOD-Wii-UEXT-NUNCHUCK/")]

Breadboard jumper wires - Male ends (to connect the Nunchuk)
#footnote[#link("https://www.olimex.com/Products/Breadboarding/JUMPER-WIRES/JW-110x10/")]

MicroSD card

#if stm32mp257-audio{[

A standard USB audio headset]}

#align(center, [#image("STM32MP257F-DK.png", width: 100%)])

#if stm32mp257-nunchuk {[#align(center, [#image("nunchuk.jpg", width: 70%)]) ]}
#align(center, [#image("common/jumper-wires.jpg", width: 70%)]) 

#if stm32mp257-audio{[ #align(center, [#image("usb-audio.png", width: 60%)]) ]}


])
