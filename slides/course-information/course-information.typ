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

===  Training quiz and certificate

- To get your training certificate you must

  + Attend all sessions of this training course

  + Achieve more than 50% of correct answers at our final quiz

    - The final quiz questions are identical to the pre-training quiz

    - The final quiz must be completed within two weeks of the session
      end's date

- The training certificate will be sent to you two weeks after the
  session end's date.

===  Participate! During the lectures...

- Don't hesitate to ask questions. Other people in the audience may have
  similar questions too.

- Don't hesitate to share your experience too, for example to compare
  Linux with other operating systems you know.

- Your point of view is most valuable, because it can be similar to your
  colleagues' and different from the trainer's.

- In on-line sessions

  - Please always keep your camera on!

  - Also make sure your name is properly filled.

  - You can also use the "Raise your hand" button when you wish to ask
    a question but don't want to interrupt.

- All this helps the trainer to engage with participants, see when
  something needs clarifying and make the session more interactive,
  enjoyable and useful for everyone.

===  Collaborate!


#table(columns: (50%, 50%), stroke: none, [ As in the Free Software
and Open Source community, collaboration between participants is
valuable in this training session:

- Use the dedicated Matrix channel for this session to add questions.

- If your session offers practical labs, you can also report issues,
  share screenshots and command output there.

- Don't hesitate to share your own answers and to help others especially
  when the trainer is unavailable.

- The Matrix channel is also a good place to ask questions outside of
  training hours, and after the course is over.

#align(center, [#image("matrix-screenshot.png", height: 80%)])

])
