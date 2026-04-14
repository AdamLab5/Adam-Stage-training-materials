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

= Principles

===  Set your goals

#table(
columns: (70%, 30%), stroke: none, gutter: 12pt,
[

- Reducing boot time implies measuring boot time!

- You will have to choose reference events at which you start and stop
  counting time.

- What you choose will depend on the goal you want to achieve. Here are
  typical cases:

  - Showing a splash screen or an animation, playing a sound to indicate
    the board is booting

  - Starting a listening service to handle a particular message

  - Being fully functional as fast as possible

],[
#align(center, [#image("stop-watch.pdf", width: 100%)])

])

===  Boot time reduction methodology

#align(center, [#image("methodology.pdf", width: 100%)])

===  Boot time components

#align(center, [#image("generic-boot-sequence.pdf", width: 100%)])

We are focusing on reducing #emph[cold] boot time, from power on to the
critical application.

===  What to optimize first 
Start by optimizing the #strong[last
steps] of the boot process!

- Don’t start by optimizing things that will reduce your ability to make
  measurements and implement other optimizations.

- Start by optimizing your applications and startup scripts first.

- You can then simplify BusyBox, reducing the number of available
  commands.

- The next thing to do is simplify and optimize the kernel. This will
  make you lose debugging and development capabilities, but this is fine
  as user space has already been simplified.

- The last thing to do is implement bootloader optimizations, when
  kernel optimizations are over and when the kernel command line is
  frozen.

We will follow this order during the practical labs.

===  Worst things first and measurement methodology 
#emph[Premature
optimization is the root of all evil. 
Donald Knuth]

- Taking the time to measure time carefully is important.

  - Advice to make at least 3 measures for each configuration you want
    to measure.

  - Pay attention to variations between measures. Measures are only
    valuable when there is a low jitter between them.

  - Keep copies of all your logs. Always useful to double check or
    analyze measures which are inconsistent with the others.

- Find the worst consumers of time and address them first.

- You can waste a lot of time if you start optimizing minor spots first.

===  Build automation

- Build automation is a very important part of a successful project.

- So, through the build system, you should automate any remaining manual
  step and all the new optimizations that you will implement to reduce
  boot time. Without such automation, you may forget some optimizations,
  or introduce new bugs when making further optimizations.

- Boot time optimization projects required countless rebuilds too,
  automating image generation will save a lot of time too.

- Kernel and bootloader compiling and optimizations can also be taken
  care of by the build system, though the need is less critical.

===  Generic ideas 
Some ideas to keep in mind while trying to reduce the boot time:

- The fastest code is code that is not executed

- A big part of booting is actually loading code and data from the
  storage to RAM. Reading less means booting faster. I/O are expensive!

- The root filesystem may take longer to mount if it is bigger.

- So, even code that is not executed can make your boot time longer.

- Also, try to benchmark different types of storage. It has happened
  that booting from SD card was actually faster than booting from NAND.
