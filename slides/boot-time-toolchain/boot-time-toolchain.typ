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

= Toolchain optimizations

===  Best toolchain for your project 
Optimizing the cross-compiling toolchain is typically one of the first things to do:

- The benefits of a toolchain change will be more significant and easier
  to measure if other optimizations haven’t been done yet.

- Here’s what you can change in a toolchain, with a potential impact on
  boot time, performance and size:

  - Components: versions of #emph[gcc] and #emph[binutils] 
    More recent versions can feature better optimization capabilities.

  - C library: #emph[glibc], #emph[uClibc], #emph[musl] 
    #emph[uClibc] and #emph[musl] libraries make a smaller root
    filesystem

  - Instruction set variant: #emph[ARM] or #emph[Thumb2] (on 32 bit
    only), #emph[Hard Float] support or not. 
    Can have an impact on code performance and code size.

    - #emph[Thumb2], available only on ARM 32, encodes the same
      instructions as #emph[ARM] but in a more compact way, at least
      significantly reducing size.

    - #emph[ARM EABIhf], in addition to being more efficient, also
      reduces code size compared to #emph[ARM EABI], but only on
      binaries doing floating point computation. For example,
      `libavcodec` size is only reduced by 4K (-0.03%). That’s
      negligible.

===  Choosing the C library

- The C library is hardcoded at toolchain creation time

- Available C libraries:

  - #emph[glibc]: most standard and featureful

  - #emph[uClibc]: smaller and configurable. Has been around for about
    20 years.

  - #emph[musl]: an alternative to #emph[uClibc], developed more
    recently but mature too.
