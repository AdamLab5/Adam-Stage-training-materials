#import "@preview/touying:0.6.0": *

#let recipient = (
    name: [],
    address: [],
)

// Colors
#let bootlin-orange = rgb("#FF631A")
#let color-link = luma(127)

#let link(dest, ..body) = {
  if body == none {body = dest}
  text(font: "DejaVu Sans Mono", size: 0.8em, fill: color-link, std.link(dest, ..body))
}

#let bootlin-doc(
  title: [],
  author: (),
  date: [],
  doc
) = {
  show heading.where( level: 1): it => block(
    width: 100%,
    inset: (bottom: 0.5em),
    stroke: (bottom: 1pt + rgb("#4B6FA9")),
    text(font: "DejaVu Sans", size: 1.2em, weight: "bold", fill: rgb("#4B6FA9"))[#it]
  )

  set page(
    paper: "a4",
    margin: (top: 22mm, bottom: 16mm, left: 15mm, right: 15mm),
    header: context [
      #set text(8pt, font: "DejaVu Sans")
      #box(image("bootlin-logo.svg"), width: 38mm) #h(1fr) Embedded Linux and kernel engineering
      #line(length: 100%, stroke: 2pt + bootlin-orange)
    ],
    header-ascent: 2mm,
    footer: context [
      #set text(8pt, font: "DejaVu Sans")
      #line(length: 100%, stroke: 0.5pt)
      #v(-5pt)
      Bootlin SAS – 
      #link("https://bootlin.com") – 9 avenue des Saules 69600 Oullins-Pierre-Bénite #if text.lang != "fr" [FRANCE] – +33 484 258 096\
      RCS Lyon No 483 248 399 – SIRET 48324839900105 – APE 6202A – TVA: FR87483248399 – Capital: 50 000 EUR
      #h(1fr)
      #counter(page).display(
        "1/1",
        both: true,
      )
    ],
    footer-descent: 2mm,
  )

  set document(title: title, author: author)
  set list(indent: 1em)
  set text(font: "DejaVu Sans")

  v(1cm)
  align(center)[
    #text(24pt)[#title]\
    #context {
      if text.lang == "fr" {
        author.join(", ", last: " et ")
      } else {
        author.join(", ", last: " and ")
      }
    }
    #text(14pt)[#date]
  ]

  v(1cm)

  set par(leading: 0.55em, justify: true)
  set text(12pt, font: "DejaVu Serif")
  doc
}

#let letter(
  recipient: recipient,
  subject: [],
  date: [],
  location: [],
  attachment: none,
  signature: none,
  doc,
) = {
  set text(12pt, font: "DejaVu Sans")

  set page(
    paper: "a4",
    margin: (top: 22mm, bottom: 16mm, left: 15mm, right: 15mm),
    header: context [
      #set text(8pt)
      #box(image("bootlin-logo.svg"), width: 38mm) #h(1fr) Embedded Linux and kernel engineering
      #line(length: 100%, stroke: 2pt + bootlin-orange)
    ],
    header-ascent: 2mm,
    footer: context [
      #set text(8pt)
      #line(length: 100%, stroke: 0.5pt)
      #v(-5pt)
      Bootlin SAS – 
      #link("https://bootlin.com") – 9 avenue des Saules 69600 Oullins-Pierre-Bénite #if text.lang != "fr" [FRANCE] – +33 484 258 096\
      RCS Lyon No 483 248 399 – SIRET 48324839900105 – APE 6202A – TVA: FR87483248399 – Capital: 50 000 EUR
      #h(1fr)
      #counter(page).display(
        "1/1",
        both: true,
      )
    ],
    footer-descent: 2mm,
  )

  [
    Bootlin #h(1fr) #location, #date\
    9 avenue des Saules \
    69600 Oullins-Pierre-Bénite \
  ]
  context {
    if text.lang != "fr" [FRANCE\
    ]
  }
  link("mailto: administration@bootlin.com")[administration\@bootlin.com]

  place(
    top+left,
    dx: 90mm,
    dy: 26mm,
    box(
      width: 9cm,
    [
      #recipient.name \
      #recipient.address
    ])
  )

  place(
    top+left,
    dx: -15mm,
    dy: 78mm,
    float: true,
    line(length: 1cm, stroke: 0.5pt),
  )

  v(3.5cm)

  context {
    if text.lang == "fr" [*Objet : *] else [*Subject: *]
    [*#subject*]
  }

  v(0.7cm)

  set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)

  doc

  if signature != none {
    v(1cm)
    h(90mm)
    box(signature)
  }

  if attachment != none {
    [
      #v(1cm)
      P.J. : #attachment
    ]
  }
}

#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    set text(size: 26pt)
    h(26mm) + utils.call-or-display(self, self.store.header)
    v(-0.8em)
    line(length: 100%, stroke: 2pt + bootlin-orange)
    v(4mm)
    place(top + left, dx: 6mm, dy: 4mm, box(image("logo-penguins.svg"), width: 18mm))
  }
  let footer(self) = {
    set text(size: 8pt)
    line(length: 100%, stroke: 0.2pt + black)
    v(-0.9em)
    h(0.5em) + utils.call-or-display(self, self.store.footer) + h(1fr) + utils.call-or-display(self, self.store.footer-right) + h(0.5em)
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )
  let new-setting = body => {
    show: setting
    v(1fr)
    body
    v(2fr)
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})


#let lab-slide(config: (:), body) = touying-slide-wrapper(self => {
  let header(self) = {
    set text(size: 26pt)
    h(26mm) + utils.call-or-display(self, self.store.header)
    v(-0.8em)
    line(length: 100%, stroke: 2pt + bootlin-orange)
    v(4mm)
    place(top + left, dx: 6mm, dy: 4mm, box(image("logo-penguins.svg"), width: 18mm))
  }
  self = utils.merge-dicts(
    self,
    config,
    config-page(
      margin: (x: 2em, top: 20mm, bottom: 1em),
      header: header
    ),
  )
  let body = {
    box(width: 40%, height: 100%, image("lab-penguins.svg"))
    box(width: 60%, height: 100%, body)
  }
  touying-slide(self: self, body)
})

#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  let header(self) = {
    set text(size: 12pt)
    [#h(1fr) Embedded Linux and kernel engineering #h(1em)]
    v(-0.8em)
    line(length: 100%, stroke: 2pt + bootlin-orange)
    v(4mm)
    place(top + left, dx: 6mm, dy: 4mm, box(image("logo-penguins.svg"), width: 18mm))
  }
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(
      margin: (x: 2em, top: 20mm, bottom: 1em),
      header: header
    ),
  )
  let info = self.info + args.named()
  let body = {
    box(width: 60%, height: 100%,
      stack(spacing: 3em,
        if info.title != none {
          text(size: 40pt,  info.title)
        },

        if info.author != none {
          text(size: 28pt, weight: "regular", info.author)
        },

        if info.date != none {
          text(
            size: 20pt,
            utils.display-info-date(self),
          )
        },
      ) + text(size: 8pt, [© Copyright 2004-#datetime.today().display("[year]"), Bootlin. \
Creative Commons BY-SA 3.0 license. \
Corrections, suggestions, contributions and translations are welcome!])
    )
    box(width: 40%, height: 100%, image("logo-square.svg"))
  }
  touying-slide(self: self, body)
})

#let new-section-slide(config: (:), level: 1, numbered: false, body) = touying-slide-wrapper(self => {
  let header(self) = {
    set text(size: 12pt)
    [#h(1fr) Embedded Linux and kernel engineering #h(1em)]
    v(-0.8em)
    line(length: 100%, stroke: 2pt + bootlin-orange)
    v(4mm)
    place(top + left, dx: 6mm, dy: 4mm, box(image("logo-penguins.svg"), width: 18mm))
  }
  let slide-body = {
    box(width: 60%, height: 100%,
      stack(spacing: 3em, dir: ttb,
        text(size: 40pt, style: "normal", utils.display-current-heading(level: level, numbered: numbered)),
        block(height: 2pt, width: 90%, spacing: 0pt,
          components.progress-bar(height: 2pt, bootlin-orange, luma(180)),
        ),
        body
      )
    )
    box(width: 40%, height: 100%, image("logo-square.svg"))
  }
  self = utils.merge-dicts(
    self,
    config-page(
      margin: (x: 2em, top: 20mm, bottom: 1em),
      header: header
    ),
  )
  touying-slide(self: self, config: config, slide-body)
})

#let new-subsection-slide(config: (:), level: 2, numbered: false, body) = touying-slide-wrapper(self => {
  let header(self) = {
    set text(size: 12pt)
    [#h(1fr) Embedded Linux and kernel engineering #h(1em)]
    v(-0.8em)
    line(length: 100%, stroke: 2pt + bootlin-orange)
    v(4mm)
    place(top + left, dx: 6mm, dy: 4mm, box(image("logo-penguins.svg"), width: 18mm))
  }
  let slide-body = {
    set align(center)
    stack(spacing: 3em, dir: ttb,
      text(size: 40pt, style: "normal", utils.display-current-heading(level: level, numbered: numbered)),
      block(height: 2pt, width: 50%, spacing: 0pt,
        components.progress-bar(height: 2pt, bootlin-orange, luma(180)),
      ),
      body
    )
  }
  self = utils.merge-dicts(
    self,
    config-page(
      margin: (x: 2em, top: 20mm, bottom: 1em),
      header: header
    ),
  )
  touying-slide(self: self, config: config, slide-body)
})

#let questions-slide(config: (:)) = touying-slide-wrapper(self => {
  let slide-body = {
    set align(center)
    stack(spacing: 3em, dir: ttb,
      text(size: 2.3em)[Questions? Suggestions? Comments?],
      v(4em),
      text(size: 1.7em, self.info.author),
      [Slides under CC-BY-SA 3.0],
    )
  }
  let footer(self) = {
    set text(size: 8pt)
    v(3pt)
    line(length: 100%, stroke: 0.2pt + black)
    v(-0.9em)
    h(0.5em) + utils.call-or-display(self, self.store.footer) + h(1fr) + utils.call-or-display(self, self.store.footer-right) + h(0.5em)
  }
  self = utils.merge-dicts(
    self,
    config-page(
      margin: (x: 2em, top: 20mm, bottom: 1em),
      footer: footer,
    ),
  )
  touying-slide(self: self, config: config, slide-body)
})

#let bootlin-theme(
  aspect-ratio: "16-9",
  header: self => utils.display-current-heading(depth: self.slide-level),
  ..args,
  body,
) = {
  set list(
    marker: (text(size: 1.5em, fill: bootlin-orange, stroke: bootlin-orange, [#v(-0.2em)‣]),
             text(size: 1em, fill: bootlin-orange, stroke: bootlin-orange, [🞄]),
             text(size: 0.5em, fill: bootlin-orange, stroke: bootlin-orange, [#v(0.2em)■])),
    indent: 1em
  )

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (x: 2em, top: 20mm, bottom: 6mm),
      footer-descent: 0.5mm,
      header-ascent: 1mm,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      new-subsection-slide-fn: new-subsection-slide,
      slide-level: 3,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: "Latin Modern Sans", size: 20pt)
        set align(horizon)

        let list-counter = counter("list")

        show list: it => {
          list-counter.step()

          context {
            set text(18pt) if list-counter.get().first() == 2
            set text(16pt) if list-counter.get().first() >= 3
            it
          }
          list-counter.update(i => i - 1)
        }
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: bootlin-orange,
      primary-light: rgb("#2159A5"),
      primary-lightest: rgb("#F2F4F8"),
      neutral-lightest: rgb("#FFFFFF")
    ),
    config-store(
      header: header,
      footer: box(image("bootlin-logo.svg"), height: 1.2em) + [ \- Kernel, drivers and embedded Linux - Development, consulting, training and support - #link("https://bootlin.com")],
      footer-right: context utils.slide-counter.display() + "/" + utils.last-slide-number,
    ),
    ..args,
  )

  body
}
