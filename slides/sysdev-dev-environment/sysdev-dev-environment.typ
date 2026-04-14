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

= Embedded Linux development environment

===  Embedded Linux solutions

- Two ways to switch to embedded Linux

  - Use #strong[solutions provided and supported by vendors] like
    MontaVista, Wind River or TimeSys. These solutions come with their
    own development tools and environment. They use a mix of open-source
    components and proprietary tools.

  - Use #strong[community solutions]. They are completely open,
    supported by the community.

- In Bootlin training sessions, we do not promote a particular vendor,
  and therefore use community solutions

  - However, knowing the concepts, switching to vendor solutions will be
    easy

===  OS for Linux development We strongly recommend to use GNU/Linux
as the desktop operating system to embedded Linux developers, for
multiple reasons.

- All community tools are developed and designed to run on Linux. Trying
  to use them on other operating systems (Windows, macOS) will lead to
  trouble.

- As Linux also runs on the embedded device, all the knowledge gained
  from using Linux on the desktop will apply similarly to the embedded
  device.

- If you are stuck with a Windows desktop, at least you should use
  GNU/Linux in a virtual machine (such as VirtualBox which is open
  source), though there could be a small performance penalty. With
  Windows 10/11, you can also run your favorite native Linux distro
  through Windows Subsystem for Linux (WSL2)

#align(center, [#image("linux-as-development-os.pdf", width: 50%)])

===  Desktop Linux distribution

0.7

- #strong[Any good and sufficiently recent Linux desktop distribution]
  can be used for the development workstation

  - Ubuntu, Debian, Fedora, openSUSE, Arch Linux, etc.

- We have chosen Ubuntu, derived from Debian, as it is a #strong[widely
  used and easy to use] desktop Linux distribution.

- The Ubuntu setup on the training laptops has intentionally been left
  untouched after the normal installation process. Learning embedded
  Linux is also about learning the tools needed on the development
  workstation!

3 #align(center, [#image("/common/ubuntu.pdf", width: 90%)]) 
Image credits: #link("https://tinyurl.com/f4zxj5kw")


===  Host vs. target

- When doing embedded development, there is always a split between

  - The #emph[host], the development workstation, which is typically a
    powerful PC

  - The #emph[target], which is the embedded system under development

- They are connected by various means: almost always a serial line for
  debugging purposes, frequently a networking connection, sometimes a
  JTAG interface for low-level debugging

#align(center, [#image("host-vs-target.pdf", width: 70%)])

===  Serial line communication program

- An essential tool for embedded development is a serial line
  communication program, like #emph[HyperTerminal] in Windows.

- There are multiple options available in Linux: #emph[Minicom],
  #emph[Picocom], #emph[Gtkterm], #emph[Putty], #emph[screen],
  #emph[tmux] and the new #emph[tio]
  (#link("https://github.com/tio/tio")).

- In this training session, we recommend using the simplest of them:
  #emph[Picocom]

  - Installation with `sudo apt install picocom`

  - Run with `picocom -b BAUD_RATE /dev/SERIAL_DEVICE`.

  - Exit with `[Ctrl][a] [Ctrl][x]`

- `SERIAL_DEVICE` is typically

  - `ttyUSBx` for USB to serial converters

  - `ttySx` for real serial ports

- Most frequent command: `picocom -b 115200 /dev/ttyUSB0`
