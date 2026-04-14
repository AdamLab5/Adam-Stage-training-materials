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

= Analyzing the build

===  Analyzing the build: available tools

- Buildroot provides several useful tools to analyze the build:#v(0.3em)

  - The #strong[licensing report], covered in a previous section, which
    allows to analyze the list of packages and their licenses.

  - The #strong[dependency graphing] tools

  - The #strong[build time graphing] tools

  - The #strong[filesystem size] tools

===  Dependency graphing

- Exploring the dependencies between packages is useful to understand

  - why a particular package is being brought into the build

  - if the build size and duration can be reduced

- `make graph-depends` to generate a full dependency graph, which can be
  huge!#v(0.3em)

- `make <pkg>-graph-depends` to generate the dependency graph of a
  given package#v(0.3em)

- The graph is done according to the current Buildroot configuration.#v(0.3em)

- Resulting graphs in `$(O)/graphs/`

===  Dependency graph example

#align(center, [#image("graph-depends.pdf", height: 100%)])

===  Build time graphing

- When the generated embedded Linux system grows bigger and bigger, the
  build time also increases.#v(0.3em)

- It is sometimes useful to analyze this build time, and see if certain
  packages are particularly problematic.#v(0.3em)

- Buildroot collects build duration data in the file
  `$(O)/build/build-time.log`#v(0.3em)

- `make graph-build` generates several graphs in `$(O)/graphs/`:

  - `build.hist-build.pdf`, build time in build order

  - `build.hist-duration.pdf`, build time by duration

  - `build.hist-name.pdf`, build time by package name

  - `build.pie-packages.pdf`, pie chart of the per-package build time

  - `build.pie-steps.pdf`, pie chart of the per-step build time#v(0.3em)

- Note: only works properly after a complete clean rebuild.

===  Build time graphing: example

#align(center, [#image("build-hist-build.pdf", width: 100%)])

===  Filesystem size graphing

- In many embedded systems, storage resources are limited.#v(0.3em)

- For this reason, it is useful to be able to analyze the size of your
  root filesystem, and see which packages are consuming the biggest
  amount of space.#v(0.3em)

- Allows to focus the size optimizations on the relevant packages.#v(0.3em)

- Buildroot collects data about the size installed by each package.#v(0.3em)

- `make graph-size` produces:

  - `file-size-stats.csv`, CSV with the raw data of the per-file size

  - `package-size-stats.csv`, CSV with the raw data of the per-package
    size

  - `graph-size.pdf`, pie chart of the per-package size consumption

===  Filesystem size graphing: example

#align(center, [#image("graph-size.pdf", height: 100%)])
