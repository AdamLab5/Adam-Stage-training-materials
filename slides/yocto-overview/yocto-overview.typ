#import "@local/bootlin:0.1.0": *
#import "@local/bootlin-yocto:0.1.0": *
#import "@local/bootlin-utils:0.1.0": *

#show: bootlin-theme.with(
  aspect-ratio: "16-9",
  config-info(
  title: [#text(size: 0.9em)[Yocto Project and OpenEmbedded:\ Recent Changes and Future Directions]],
  author: [#v(-30pt)#text(size: 0.8em)[Antonin Godard\ _antonin.godard\@bootlin.com_]],
  date: [#v(-30pt)#text(size: 0.8em)[Embedded Recipes 2025]],
  institution: [Bootlin],
),
config-common(
  // Compile with `typst c --input handout=1 ...` to generate the handout.
  handout: "handout" in sys.inputs and sys.inputs.handout == "1",
))
 
#show raw.where(block: false): r => { text(fill: color-link)[#r] } 
 = Yocto Project and Poky reference system overview
<yocto-project-and-poky-reference-system-overview>
== The Yocto Project overview
<the-yocto-project-overview>
=== 

=== About
<about>
- The Yocto Project is an open source collaboration project that allows
  to build custom embedded Linux-based systems.

- Established by the Linux Foundation in 2010 and still managed by one
  of its fellows: Richard Purdie.

===  Yocto: principle

#image("yocto-principle.pdf", width: 100%)

===  Lexicon: ```bitbake``` In Yocto / OpenEmbedded, the #emph[build
engine] is implemented by the ```bitbake``` program

- ```bitbake``` is a task scheduler, like ```make```

- ```bitbake``` parses text files to know what it has to build and how

- It is written in Python (need Python 3 on the development host)

===  Lexicon: recipes

- The main kind of text file parsed by ```bitbake``` is #emph[recipes],
  each describing a specific software component

- Each #emph[Recipe] describes how to fetch and build a software
  component: e.g. a program, a library or an image

- They have a specific syntax

- ```bitbake``` can be asked to build any recipe, building all its
  dependencies automatically beforehand

#image("recipe-dependencies.pdf", width: 90%)

===  Lexicon: tasks

- The build process implemented by a recipe is split in several
  #emph[tasks]

- Each task performs a specific step in the build

- Examples: fetch, configure, compile, package

- Tasks can depend on other tasks (including on tasks of other recipes)

#image("recipe-dependencies-tasks.pdf", width: 100%)

===  Lexicon: metadata and layers

- The input to ```bitbake``` is collectively called #emph[metadata]

- Metadata includes #emph[configuration files], #emph[recipes],
  #emph[classes] and #emph[include files]

- Metadata is organized in #emph[layers], which can be composed to get
  various components

  - A layer is a set of recipes, configurations files and classes
    matching a common purpose

    - For Texas Instruments board support, the #emph[meta-ti-bsp] layer
      is used

  - Multiple layers are used for a project, depending on the needs

- #emph[openembedded-core] is the core layer

  - All other layers are built on top of openembedded-core

  - It supports the ARM, MIPS (32 and 64 bits), PowerPC, RISC-V and x86
    (32 and 64 bits) architectures

  - It supports QEMU emulated machines for these architectures

===  Lexicon: Poky

- The word #emph[Poky] has several meanings

- Poky is a git repository that is assembled from other git
  repositories: bitbake, openembedded-core, yocto-docs and meta-yocto

- poky is the #emph[reference distro] provided by the Yocto Project

- meta-poky is the layer providing the poky reference distribution

===  The Yocto Project lexicon

#image("yocto-project-overview.pdf", height: 80%)

=== 

=== The Yocto Project lexicon
<the-yocto-project-lexicon>
- The Yocto Project is #strong[not used as] a finite set of layers and
  tools.

- Instead, it provides a #strong[common base] of tools and layers on top
  of which custom and specific layers are added, depending on your
  target.

=== 

=== Example of a Yocto Project based BSP
<example-of-a-yocto-project-based-bsp>
- To build images for a BeagleBone Black, we need:

  - The Poky reference system, containing all common recipes and tools.

  - The #emph[meta-ti-bsp] layer, a set of Texas Instruments specific
    recipes.

- All modifications are made in your own layer. Editing Poky or any
  other third-party layer is a #strong[no-go]!

- We will set up this environment in the lab.

== The Poky reference system overview
<the-poky-reference-system-overview>
=== 

=== Getting the Poky reference system
<getting-the-poky-reference-system>
- All official projects part of the Yocto Project are available at
  #link("https://git.yoctoproject.org/")

- To download the Poky reference system: \

- A new version is released every 6 months, and maintained for 7 months

- #strong[LTS] versions are maintained for 4 years, and announced before
  their release.

- Each release has a codename such as ```kirkstone``` or ```scarthgap```,
  corresponding to a release number.

  - A summary can be found at
    #link("https://wiki.yoctoproject.org/wiki/Releases")

===  Poky

#image("yocto-overview-poky.pdf", height: 80%)

=== 

=== Poky source tree 1/2
<poky-source-tree-12>
Holds all scripts used by the ```bitbake``` command. Usually matches the
stable release of the BitBake project.

All documentation sources for the Yocto Project documentation. Can be
used to generate nice PDFs.

Contains the OpenEmbedded-Core metadata.

Contains template recipes for BSP and kernel development.

=== 

=== Poky source tree 2/2
<poky-source-tree-22>
Holds the configuration for the Poky reference distribution.

Configuration for the Yocto Project reference hardware board support
package.

The license under which Poky is distributed (a mix of GPLv2 and MIT).

Script to set up the OpenEmbedded build environment. It will create the
build directory.

Contains scripts used to set up the environment, development tools, and
tools to flash the generated images on the target.

=== 

=== Documentation
<documentation>
- Documentation for the current sources, compiled as a \"mega manual\",
  is available at:
  #link("https://docs.yoctoproject.org/singleindex.html")

- Variables in particular are described in the variable glossary:
  #link("https://docs.yoctoproject.org/genindex.html")
