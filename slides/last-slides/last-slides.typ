#let trainer

#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "/typst/local/themeBootlin.typ": *

#import "/typst/local/common.typ": *

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

= Last slides

#if trainer == none{[

===  Evaluation and final quiz

- Rate this training session and provide your feedback:

  #link("sessionurl/survey.html")[sessionurl/survey.html]


===  Evaluation and final quiz

- Rate this training session and provide your feedback:

  #link("sessionurl/survey.html")[sessionurl/survey.html]

- Fill in the final quiz to assess your level of knowledge on the topics
  covered in this course. To get the training certificate, you must have
  attended all sessions, and get at least 50% of correct answers at this
  final quiz:

  #link("sessionurl/quiz-after.html")[sessionurl/quiz-after.html]

  The final quiz must be filled in within two weeks of the training
  end's date.

  The training certificate is sent two weeks after the training end's
  date.
- Fill in the final quiz to assess your level of knowledge on the topics
  covered in this course. To get the training certificate, you must have
  attended all sessions, and get at least 50% of correct answers at this
  final quiz:

  #link("sessionurl/quiz-after.html")[sessionurl/quiz-after.html]

  The final quiz must be filled in within two weeks of the training
  end's date.

  The training certificate is sent two weeks after the training end's
  date.]
}

===  Last slide

Thank you! 
And may the Source be with you 

===  Rights to copy © Copyright 2004-, Bootlin 
#strong[License: Creative Commons Attribution - Share Alike 3.0] 
#link("https://creativecommons.org/licenses/by-sa/3.0/legalcode") 
You are free:

- to copy, distribute, display, and perform the work

- to make derivative works

- to make commercial use of the work

Under the following conditions:

- #strong[Attribution]. You must give the original author credit.

- #strong[Share Alike]. If you alter, transform, or build upon this
  work, you may distribute the resulting work only under a license
  identical to this one.

- For any reuse or distribution, you must make clear to others the
  license terms of this work.

- Any of these conditions can be waived if you get permission from the
  copyright holder.

Your fair use and other rights are in no way affected by the above.
#strong[Document sources:]
#link("https://github.com/bootlin/training-materials/") 
