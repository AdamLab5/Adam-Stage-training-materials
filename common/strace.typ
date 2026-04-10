#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "../typst/local/themeBootlin.typ": *

#import "../typst/local/common.typ": *

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


r

}

===  strace

#columns(gutter: 8pt)[ System call tracer - #link("https://strace.io")

- Available on all GNU/Linux systems 
  Can be built by your cross-compiling toolchain generator or by your
  build system.

- Allows to see what any of your processes is doing: accessing files,
  allocating memory... Often sufficient to find simple bugs.

- Usage: 
  `strace <command>` (starting a new process) 
  `strace -f <command>` (#strong[f]ollow child processes too) 
  `strace -p <pid>` (tracing an existing process) 
  `strace -c <command>` (time statistics per system call) `strace -e
  <expr> <command>` (use #strong[e]xpression for advanced filtering)

See
#link("https://man7.org/linux/man-pages/man1/strace.1.html")[the strace manual]
for details #colbreak()
#align(center, [#image("strace-mascot.png", height: 70%)]) 
Image credits: #link("https://strace.io/") 
]

===  strace example output
#align(center, [#image("strace-output.pdf", height: 75%)]) 
Hint: follow the open file descriptors returned by `open()`. This tells
you what files are handled by further system calls.

===  strace filtering

- Display only a specific set of system calls:
#text(size: 20pt)[
```console
$ strace -e 'openat,write' cat Makefile
```]

- Filter out specific system calls:
#text(size: 18pt)[

```console
$ strace -e '!poll' cat Makefile
```
]
- Show only system calls returning a specific status
#text(size: 18pt)[

```console
$ strace -e 'status=failed' cat Makefile
```
]
- Trace how a file is accessed and used among different system calls
#text(size: 18pt)[

```console
$ strace -P '/etc/ld.so.cache' cat Makefile
```
]
- Run `strace –tips` to learn new commands !
