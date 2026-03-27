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

= Alternatives
<alternatives>
===  Suspend to RAM

- Used mostly on phones (Android, Firefox OS, ...) and PCs.

- May drain the battery too fast in devices that are idle most of the
  time or for a long time (e.g. digital cameras, motion detecting video
  surveillance).

===  Hibernate

- Also called suspend to disk.

- Used in SONY digital cameras (booting in about 1s).

- Used in credit card payment terminals (our customer).

- Requires sufficient amount of RAM and storage (NAND, eMMC, ...).
  Storage has to be fast enough.

===  Checkpointing

- Similar to hibernate, but the state of the system is selectively saved
  to disk. It will require less storage and will probably boot faster.

- For Android, have a look at:
  #link("https://www.elinux.org/images/1/1c/Implement_Checkpointing_for_Android.pdf")[https://www.elinux.org/images/1/1c/Implement_Checkpointing_for_Android.pdf]
