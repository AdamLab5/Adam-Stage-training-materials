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
 = About Bootlin
<about-bootlin>
===  Bootlin introduction

- Engineering company

  - In business since 2004

  - Before 2018: #emph[Free Electrons]

- Team based in France and Italy

- Serving #strong[customers worldwide]

- #strong[Highly focused and recognized expertise]

  - Embedded Linux

  - Linux kernel

  - Embedded Linux build systems

- #strong[Strong open-source] contributor

- Activities

  - #strong[Engineering] services

  - #strong[Training] courses

- #link("https://bootlin.com")

#image("../../common/bootlin-logo.pdf", width: 100%)

===  Bootlin engineering services

#image("../../slides/about-us/engineering-services.pdf", height: 80%)

===  Bootlin training courses

#image("../../slides/about-us/training-courses.pdf", height: 70%)

===  Bootlin, an open-source contributor

- Strong contributor to the #strong[Linux] kernel

  - In the top 30 of companies contributing to Linux worldwide

  - Contributions in most areas related to hardware support

  - Several engineers maintainers of subsystems/platforms

  - 9000 patches contributed

  - #link("https://bootlin.com/community/contributions/kernel-contributions/")

- Contributor to #strong[Yocto Project]

  - Maintainer of the official documentation

  - Core participant to the QA effort

- Contributor to #strong[Buildroot]

  - Co-maintainer

  - 6000 patches contributed

- Significant contributions to U-Boot, OP-TEE, Barebox, etc.

- Fully #strong[open-source training materials]

===  Bootlin on-line resources

- Website with a technical blog: \
  #link("https://bootlin.com")

- Engineering services: \
  #link("https://bootlin.com/engineering")

- Training services: \
  #link("https://bootlin.com/training")

- LinkedIn: \
  #link("https://www.linkedin.com/company/bootlin")

- Elixir - browse Linux kernel sources on-line: \
  #link("https://elixir.bootlin.com")

#image("../../slides/about-us/www.png", width: 70%) \
#emph[Icon by Freepik, Flaticon]
