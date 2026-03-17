
#let titleframe()={


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

#let todo(arg1) = {
   "TODO: " + arg1 // Ajouter large et color red
}

// \newcommand\todo[1]{
//   {\large \color{red}TODO: #1}
// }


// \usemintedstyle{perldoc}

// Create a slide announcing a lab, with the beautiful worker penguin
// on the left.
// first argument: slide title (will be prepended by 'Practical lab - ')
// second argument: contents of the slide.

#let setuplabframe(arg1, arg2) = {
    heading("Practical lab - "+arg1,depth:3)
    image("../../common/lab-penguins.svg", width: 100%)
}

// \newcommand\setuplabframe[2]{
//   \begin{frame}{Practical lab - #1}
//     \begin{columns}
//       \column{0.4\textwidth}
//       \includegraphics[width=\textwidth]{common/lab-penguins.pdf}
//       \column{0.6\textwidth}
//       #2
//       \end{columns}
//   \end{frame}
// }

#let setupdemoframe(arg1, arg2) = {
    heading("Demo - "+ arg1,depth:3, )
    image("../../common/lab-penguins.svg", width: 5%)
}

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