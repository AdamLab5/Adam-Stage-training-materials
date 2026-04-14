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

= Measuring

===  Time measurement equipment: hardware

- The best equipment is an oscilloscope, if you can afford one

- Allows to time the "Power on" event (connected to a power rail), or
  any event (connected to a GPIO pin, for example), all this in a very
  accurate way.

- Easy to write to a GPIO at all the stages of system booting (we will
  explain how to do it)

- Some oscilloscopes are getting affordable. Example: Bitscope Pocket
  Analyzer (245 AUD, supported on Linux,
  #link("https://www.bitscope.com/product/BS10/"))

#align(center, [#image("mothinator_Oscilloscope.pdf", width: 35%)])

===  Measuring with hardware: using an Arduino
#table(
columns: (80%, 20%), stroke: none,
[
 #link("https://arduino.cc")

- If you don’t have an oscilloscope, an Arduino (or any general purpose
  MCU or MPU board) is a good solution too.

- The main strength of Arduino is its great ease of use and programming,
  plus all the hardware support libraries that are available.

- You can easily connect board pins to the Arduino analog pins, and
  watch their voltage.

- Arduino boards are Open Source Hardware. This project is definitely
  worth supporting!

],[
#align(center, [#image("arduino-logo.pdf", width: 65%)]) 
#[#set text(size: 18pt) 
#v(2em)
#align(center, "Arduino Nano") ]
#align(center, [#image("arduino-nano.jpg", width: 60%)])
#[
  #set text(size: 12pt)
#align(center, [Image credits: #link("https://commons.wikimedia.org/wiki/File:Arduino_nano_isometr.jpg")[https://commons.wikimedia.org/wiki/File:Arduino_nano_isometr.jpg]])
]
#[
  #v(1.5em)
#align(center, [#image("common/open-source-hardware-logo.pdf", width: 55%)])
]

])

===  Time measurement equipment: serial port
#table(
columns: (80%, 20%), stroke: none, 
[
#[
  #set text(size: 18pt)
  #set list(spacing: 1em)
- Useful when you don’t have monitoring hardware, or don’t want to make
  take any risk connecting wires to the hardware.

- Usually relies on software which times messages received from the
  board’s serial port (serial port absolutely required). Such software
  runs on a PC connected to the serial port.

- On the board, requires a real serial port (directly connected to the
  CPU), immediately usable from the earliest parts of the boot process.
  Attaching a USB-to-serial dongle to a USB #strong[host] port on the
  device won’t do: USB is available much later and messages go through
  more complex software stacks (loss of time accuracy).

- Limitation: won’t be able to time the "Power on" event in an
  accurate way. But acceptable as you can assume that the time to run
  the ROM code is constant.]
],[
#align(center, [#image("serial_db9_female.pdf", width: 100%)])
#v(3em)
#align(center, [#image("GS_USB_Cable.pdf", width: 100%)])

])

===  grabserial #link("https://elinux.org/Grabserial") (by Tim Bird)

- A Python script to add timestamps to messages received on a serial
  console.

- Key advantage: starts counting very early (ROM code — if not silent,
  bootstrap and bootloader)

- Another advantage: no overhead on the target, because run on the host
  machine.

- Drawbacks: may not be precise enough. Can’t measure power up time.

- Ubuntu package: `grabserial` 
  Otherwise available on
  #link("https://github.com/tbird20d/grabserial/")

===  Using grabserial

#align(center, [#image("using-grabserial.pdf", height: 65%)])

#strong[Caution]: `grabserial` shows the arrival time of the
#strong[first character] of a line. This doesn’t mean that the entire
line was received at that time.

===  grabserial tips

- You can interrupt `grabserial` manually (with `[Ctrl][c]`) when
  you have gone far enough.

- The `-m` (#strong[m]atch start pattern) and `-q` ( #strong[q]uit
  pattern) options actually expect a regular expression. A normal string
  may not match in the middle of a line.

- Example: you may have to replace `-m "Starting kernel"` by `-m ".*Starting kernel.*"`.

- You can store a copy of the output to a file using the `-o` option. No
  need to copy / paste or redirect the output to keep it.

===  Dedicated measuring resources 
Later, we will see specific resources for measuring time

- `time` for measuring application time

- `strace` for application tracing

- `bootchartd` for measuring and tracing the execution of system
  services.

- More specifically, `systemd-analyze` if your system is started with
  #emph[Systemd].

- #kconfig("CONFIG_PRINTK_TIME") and `initcall_debug` for tracing
  and timestamping kernel code and functions.

#setuplabframe([Measuring time],[ Measuring time with software

- Setting up `grabserial`

- Modify the video player to log a notification after the first frame is
  processed.

- Time the various components of boot time through messages written to
  the serial console.

])
