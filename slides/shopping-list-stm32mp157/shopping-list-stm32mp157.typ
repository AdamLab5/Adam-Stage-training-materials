#import "../../common/embedded-linux-vars.typ": *

#let stm32mp157-nunchuk = false 
#if training == "yocto" {
  [#let stm32mp157-nunchuk = true]} 
#if training == "buildroot"{ 
[#let stm32mp157-nunchuk = true]
}
#if training == "embedded-linux" {
[#let stm32mp157-nunchuk = true ]
}
#if training == "linux-kernel" {
[#let stm32mp157-nunchuk = true]
}
#let stm32mp157-audio = false
#if training == "embedded-linux"{
[#let stm32mp157-audio = true]
}

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

===  STM32MP157 shopping list


#table(columns: (50%, 50%), stroke: none, [

Discovery Kits from STMicroelectronics: STM32MP157A-DK1,
STM32MP157D-DK1, STM32MP157C-DK2 or STM32MP157F-DK2 #footnote[Boards
documentation:
#link("https://www.st.com/en/evaluation-tools/stm32mp157a-dk1.html")[A-DK1],
#link("https://www.st.com/en/evaluation-tools/stm32mp157d-dk1.html")[D-DK1],
#link("https://www.st.com/en/evaluation-tools/stm32mp157c-dk2.html")[C-DK2],
#link("https://www.st.com/en/evaluation-tools/stm32mp157f-dk2.html")[F-DK2]]

- STM32MP157 (Dual Cortex-A7 + Cortex-M4) CPU

- 512 MB DDR3L RAM

- Plenty of periperals: GPIOs, SPI, Serial, USB, ethernet...

MicroUSB cable (to access the serial console)

USB-C to USB-A cable (to power the board)

#if stm32mp157-nunchuk{
[- Nintendo Nunchuk with UEXT connector]}
#footnote[#link("https://www.olimex.com/Products/Modules/Sensors/MOD-WII/MOD-Wii-UEXT-NUNCHUCK/")]

Breadboard jumper wires - Male ends (to connect the Nunchuk)
#footnote[#link("https://www.olimex.com/Products/Breadboarding/JUMPER-WIRES/JW-110x10/")]

MicroSD card

RJ45 cable

#if stm32mp157-audio{
[- A standard USB audio headset]
}
#align(center, [#image("discovery-board-dk1.png", width: 60%)])

#if stm32mp157-nunchuk {[
- #align(center, [#image("nunchuk.jpg", width: 60%)]) ]}
#align(center, [#image("../../common/jumper-wires.jpg", width: 60%)]) 

#if stm32mp157-audio {[#align(center, [#image("usb-audio.png", width: 60%)])]}


])
