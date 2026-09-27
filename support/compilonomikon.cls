\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{compilonomikon}[2026/09/27 Compilonomikon book class]
\LoadClass[11pt,openany]{book}
\RequirePackage{xparse}
\RequirePackage{hyperref}
\RequirePackage{multicol}
\RequirePackage{booktabs}
\RequirePackage{cck-listings}
\RequirePackage{cck-tables}

\hypersetup{colorlinks=true,linkcolor=blue,citecolor=blue,urlcolor=blue}
\setlength{\columnsep}{1.5em}
\newcounter{kernel}[chapter]
\renewcommand{\thekernel}{\thechapter.\arabic{kernel}}
\NewDocumentCommand{\kernelname}{m}{\texttt{#1}}
\NewDocumentCommand{\kernelref}{m}{%
  \hyperref[kernel:#1]{\kernelname{#1} (Chapter~\ref*{kernel-chapter:#1}, p.~\pageref*{kernel:#1})}%
}
\NewDocumentEnvironment{kernel}{m m}{%
  \par\medskip\refstepcounter{kernel}\label{kernel:#1}%
  \begingroup\def\@currentlabel{\thechapter}\label{kernel-chapter:#1}\endgroup
  \noindent\textbf{Kernel \thekernel: \kernelname{#1}}\par
  \noindent\emph{#2}\par\smallskip
  \begin{multicols}{2}
}{%
  \end{multicols}\par\medskip
}
\NewDocumentEnvironment{case-study}{m}{%
  \par\medskip\noindent\textbf{Case study: #1}\par\smallskip
}{\par\medskip}
