#import "@local/bootlin:0.1.0": *
#import "@local/bootlin-yocto:0.1.0": *
#import "@local/bootlin-utils:0.1.0": *
#import "../../typst/local/themeBootlin.typ": *
#import "../../typst/local/common.typ": *
#show: bootlin-theme.with(
  aspect-ratio: "16-9",

config-common(
  // Compile with `typst c --input handout=1 ...` to generate the handout.
  handout: "handout" in sys.inputs and sys.inputs.handout == "1",
))
#show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius:0.5em, width:100%)
#show raw.where(block: false): r => { text(fill: color-link)[#r] } 

= Autotools references
<autotools-references>
===  Existing code

- Lots of open-source projects are using the #emph[autotools]

- They provide a lot of examples on how to configure and build things
  using the #emph[autotools]

- However, make sure to have a critical eye when reading existing
  #emph[autotools] code

  - For a lot of developers, the build system part is not their primary
    knowledge and interest

  - Lots of projects use deprecated constructs or truely horrible
    solutions

  - Don’t copy/paste without thinking!

===  Book: #emph[Autotools, a practitioner’s guide]

#columns(gutter: 8pt)[

- #strong[Autotools, A Practitioner’s Guide to GNU Autoconf, Automake,
  and Libtool]

- John Calcote

- No Starch Press

- #link("https://www.nostarch.com/autotools.htm")

- Excellent book.

#colbreak()
#align(center, [#image("autotools-book.png", width: 60%)]) 
]

===  Official documentation

#columns(gutter: 8pt)[

- The official reference documentation from GNU is also very good, once
  you have a good understanding of the basics.

- Autoconf 
  #link("https://www.gnu.org/software/autoconf/manual/")

- Automake 
  #link("https://www.gnu.org/software/automake/manual/")

- Libtool 
  #link("https://www.gnu.org/software/libtool/manual/")

#colbreak()
#align(center, [#image("automake-manual.png", width: 100%)])

]

===  Tutorials

#columns(gutter: 8pt)[

- #strong[Autotools tutorial], Alexandre Duret-Lutz,
  #link("https://www.lrde.epita.fr/~adl/autotools.html")

- #strong[Autotools Mythbuster], Diego Elio "Flameeyes" Pettenò,
  #link("https://autotools.io/")

- #strong[Introduction to the Autotools], David Wheeler, including a
  video, #link("https://www.dwheeler.com/autotools/")

#colbreak()
#align(center, [#image("autotools-tutorial.png", width: 100%)])

]

===  Use up to date materials

- Be careful to use up-to-date material

  - For example, the well-known book #emph[GNU Autoconf, Automake and
    Libtool”] by Gary Vaughan et al., published originally in 2000 is
    completely out of date

  - Even though #emph[autotools] are old, they have evolved quite
    significantly in recent times!
