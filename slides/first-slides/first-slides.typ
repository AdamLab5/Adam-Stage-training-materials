'#import "../../out/vars.typ": trainer
#if trainer==none{

  [#import "@local/bootlin:0.1.0": *

  #import "@local/bootlin-yocto:0.1.0": *

  #import "@local/bootlin-utils:0.1.0": *

  #import "../../typst/local/themeBootlin.typ": *

  #import "../../typst/local/common.typ": *

  #show: bootlin-theme.with( aspect-ratio: "16-9", config-common(handout: "handout" in sys.inputs and sys.inputs.handout == "1", ))

  #show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius: 0.5em, width: 100%)

  #show raw.where(block: true): set text(size: 11pt)

  #show raw.where(block: false): r => text(fill: color-link)[#r]

  #show raw.where(lang: "c", block: true): set block(fill: luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt, below: 12pt)

  #show raw.where(lang: "c", block: true): set text(11pt)

  #show raw.where(lang: "console", block: true):set block(fill: luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 6pt)

  #show raw.where(lang:"console", block: true): set text(12pt)

  === training
      
  #table(columns: (50%, 50%), stroke: none,
  [
    - These slides are the training materials for Bootlin's
      #emph[training course].
    - If you are interested in following this course with an
        experienced Bootlin trainer, we offer:
        - Public online sessions, opened to individual
          registration. Dates announced on our site, registration
          directly online.
        - Dedicated online sessions, organized for a team of
          engineers from the same company at a date/time chosen by our
          customer.
        - Dedicated on-site sessions, organized for a team of
          engineers from the same company, we send a Bootlin trainer
          on-site to deliver the training.
      - Details and registrations: #link("https://bootlin.com/training/\training")
      - Contact: `training@bootlin.com`
      ],[
      #image("../../common/training.png")
      #emph[Icon by Eucalyp, Flaticon]
    ])]
    
    }else{
      [#include "../slides/first-slides/"+trainer+".typ"]
    }

// If the materials a generated for a real session, not for the website

#if trainer==none{
  [=== Electronic copies of these documents
        - Electronic copies of your particular version of the
              materials are available on:
              #link("\sessionurl")
        - You can download and open these documents to follow
	      lectures and labs, to look for explanations given earlier
              by the trainer and to copy and paste text during labs.
        - This specific URL will remain available for a long time.
	      This way, you can always access the exact instructions
              corresponding to the labs performed in this session.
        - If you are interested in the latest versions of our
	      training materials, visit the description of each
              course on #link("https://bootlin.com/training")
  ]
}
