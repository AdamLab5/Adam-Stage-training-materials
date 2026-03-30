#import "./common.typ":

#set page(
  margin: 1.5cm,
)

#set text(
  font: "Latin Modern Roman",
  size: 1pt
)

// #set heading(
//   font: "Latin Modern Sans",
//   weight: "bold"
// )

#let blorange = rgb("F57F19")
#let blcode = rgb("595959")
#let blcodebg = rgb("E6E6E6")
#let bldarkblue = rgb("4040BF")

// #set link()(
//   bldarkblue
// )

#let codelink(title, body) = [
  #set text(fill: bldarkblue)
  #link(body)[#title]
]

#let codeblock(body) = block(
  fill: blcodebg,
  inset: 8pt,
  radius: 6pt,
)[
  #set text(font: "Inconsolata", fill: blcode, size: 9pt)
  #body
]

#let frame(title, body) = [
  #block[
    #set text(size: 16pt, weight: "bold")
    #box(
      width: 100%,
      inset: 6pt,
      fill: white
    )[
    '  #image("../../out/common/logo-penguins.pdf", width: 1cm)
      #h(1em)
      #title
    ]
    #line(length: 100%, stroke: (paint: blorange, thickness: 1pt))
  ]

  #v(1em)
  #body

  #v(1fr)

  #line(length: 100%, stroke: 0.5pt)

  #grid(
    columns: (1fr, auto),
    [
      #text(size: 8pt)[
        Kernel, drivers and embedded Linux —  
        Development, consulting, training and support —  
        https://bootlin.com
      ]
    ],
    // [
    //   #counter(page).display() / #counter(page).final()
    // ]
  )
]

#let titleframe(title) = frame(
  title + " training",
  grid(
    columns: 2,
    gutter: 1cm,
    [
      #text(size: 20pt, weight: "bold")[#title training]

      #v(2em)

      #text(size: 8pt)[
        © Copyright 2004-#datetime.today().year, Bootlin  
        Creative Commons BY-SA 3.0  
      ]

      #v(1em)

      #link("https://bootlin.com/training/")
    ],
    [
      #align(center)[
        #image("../../out/common/logo-square.pdf", height: 4cm)
      ]
    ]
  )
)

#let sectionframe(title) = frame(
  title,
  grid(
    columns: 2,
    [
      #text(size: 24pt, weight: "bold")[#title]
    ],
    [
      #align(center)[
        #image("../../out/common/logo-square.pdf", scale: 45%)
      ]
    ]
  )
)

#let labframe(title, body) = frame(
  "Practical lab - " + title,
  grid(
    columns: (0.4fr, 0.6fr),
    [
      #image("../../out/common/lab-penguins.pdf", width: 100%)
    ],
    [
        #body
    ]
  )
)

#let setuplabframe(title, body) = {

    heading("Practical lab - "+ title, depth: 3)

    grid(
      columns: (0.4fr, 0.6fr),
      column-gutter: 1cm,
      align: horizon,
      [
        #image("../../common/lab-penguins.svg", width: 100%)
      ],
      body
    )
}


#let kfunc(body) = {
    "https://elixir.bootlin.com/linux/latest/ident/" + body
}

#let setupdemoframe(title, body) = {
  heading("Demo - " + title, depth: 3)
  
  grid(
    columns: (0.4fr, 0.6fr),
    column-gutter: 1cm,
    align: horizon,
    [
      #image("../../out/common/lab-penguins.pdf", width: 100%)
    ],
    body
  )
}

#let todo(arg1) = {
   "TODO: " + arg1 // Ajouter large et color red
}

// \newcommand\titleframe
// {
//   \begin{frame}{\trainingtitle{} training}
//     \begin{columns}[b]
//       \column{0.5\textwidth}
//       \Large
//       \trainingtitle{} training\\
//       \vspace{3em}
//       \footnotesize
//       \tinyv
//       © Copyright 2004-\the\year, Bootlin.\\
//       Creative Commons BY-SA 3.0 license.\\
//       Latest update: \lastupdateen{}.\\
//       \vspace{1em}
//       Document updates and training details:\\
//       \url{https://bootlin.com/training/\training}\\
//       \vspace{1em}
//       Corrections, suggestions, contributions and translations are welcome!\\
//       Send them to \href{mailto:feedback@bootlin.com}{feedback@bootlin.com}
//       \column{0.5\textwidth}
//       \begin{center}
//         \includegraphics[height=4cm]{common/logo-square.pdf}
//       \end{center}
//     \end{columns}
//   \end{frame}
// }

// \AtBeginSection[]
// {
//   \begin{frame}{\insertsectionhead}
//     \begin{columns}[b]
//       \column{0.5\textwidth}
//       \huge
//       \insertsection\\
//       \vspace{1.5cm}
//       \footnotesize
//       \vspace{1cm}
//       \tinyv
//       © Copyright 2004-\the\year, Bootlin.\\d
//       Creative Commons BY-SA 3.0 license.\\
//       Corrections, suggestions, contributions and translations are welcome!
//       \column{0.5\textwidth}
//       \begin{center}
//         \includegraphics[scale=0.45]{common/logo-square.pdf}
//       \end{center}
//     \end{columns}
//   \end{frame}
// }

// \AtBeginSubsection[]
// {
//   \begin{frame}{\insertsectionhead}
//     \huge
//     \begin{center}
//       \insertsubsection
//     \end{center}
//   \end{frame}
// }

// \newcommand\todo[1]{
//   {\large \color{red}TODO: #1}
// }


// \usemintedstyle{perldoc}

// Create a slide announcing a lab, with the beautiful worker penguin
// on the left.
// first argument: slide title (will be prepended by 'Practical lab - ')
// second argument: contents of the slide.


// \newcommand\setuplabframe[2]{
//   \begin{frame}{Practical lab - #1}
//     \begin{columns}
//       \column{0.4\textwidth}
//       \includegraphics[width=\textwidth]{common/lab-penguins.pdf}
//       \column{0.6\textwidth}
//       #2
//       \end{columns}
//   \end{frame}
// // }

// #let setupdemoframe(arg1, arg2) = {
//     heading("Demo - "+ arg1,depth:3, )
//     image("../../out/common/lab-penguins.pdf", width: 100%)
// }

// \newcommand\setupdemoframe[2]{
//   \begin{frame}{Demo - #1}
//     \begin{columns}
//       \column{0.4\textwidth}
//       \includegraphics[width=\textwidth]{common/lab-penguins.pdf}
//       \column{0.6\textwidth}
//       #2
//       \end{columns}
//   \end{frame}
// }