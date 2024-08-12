\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv_template}[Resume Template]

\usepackage{import}

\RequirePackage{xkeyval}
\RequirePackage{etoolbox}

%% Options
\newbool{fitbool}
\newbool{framebool}
\newcommand{\cvmargins}{0.5in}
\DeclareOptionX{cvmargins}[0.5in]{\renewcommand{\cvmargins}{#1}}
\newcommand{\coverlettermargins}{1in}
\DeclareOptionX{coverlettermargins}[1in]{\renewcommand{\coverlettermargins}{#1}}
\DeclareOptionX{fstyle}[cormorantgaramond]{\def\@fstyle{#1}}
\DeclareOptionX{link}[true]{\def\@link{ocgcolorlinks=#1}}
\DeclareOptionX{icon}[true]{\setbool{iconbool}{#1}}
\DeclareOptionX{fit}[true]{\setbool{fitbool}{#1}}
\DeclareOptionX{frame}[true]{\setbool{framebool}{#1}}

%% Default Options
\ExecuteOptionsX{
  fstyle=cormorantgaramond,
  link=false,
  fit=false,
  frame=false
}

\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptionsX*
\LoadClass{article}

\RequirePackage{ulem} % underlining without disruption
\RequirePackage{array} % tabular and array environments
\RequirePackage{substr} % substring manipulation
\RequirePackage{environ} % allows use of macros on entire body of environment
\RequirePackage{multicol} % Enables multicolumn tables
\RequirePackage{enumitem} % itemized lists
\RequirePackage{scalerel} % scaling and stretching of objects
\RequirePackage{fontspec} % set new font faces
\RequirePackage{stackengine} % customized object stacking
\RequirePackage[nomessages]{fp} % fixed point arithmetic
\RequirePackage[empty]{fullpage} % remove page numbers
\RequirePackage[parfill]{parskip} % removes indent & sets spacing
\RequirePackage{geometry}
\RequirePackage[\@link]{hyperref} % web links
\RequirePackage{lipsum}

%% Set font style
\setmainfont{\@fstyle}

%% Reference Settings
\hypersetup{
  allcolors=DarkBlue,
  pdfpagelayout=SinglePage,
  pdfpagemode=FullScreen,
  pdfdisplaydoctitle,
  pdfstartview=Fit,
  pdflang={en-US},
  debug,
  final
}

%% Header
%% [5]: {<name>} {<phone>} {<email>} {<linkedIn>} {<github>}
\newcommand{\header}[5]{
    \def\name{#1}
    \def\phone{#2}
    \def\email{#3}
    \notblank{#4}{\def\linkedin{#4}}{}
    \notblank{#5}{\def\github{#5}}{}
}

\newcommand{\printcvheader}{
    \centering
    {\nameform \name}\nameskip
    \mbox{\contform \phone}\contsep
    \mbox{\contform \email}\contsep
    \ifdefined\linkedin
        \mbox{\contform \linkedin}\contsep
    \fi
    \ifdefined\github
        \mbox{\contform \github}\contsep
    \fi
    \headerskip
}

%%-------------------------------
%% CV
%%-------------------------------
\newenvironment*{cv}{
    \clearpage
    \newgeometry{margin=\cvmargins}
    \printcvheader
}{
    \restoregeometry
}

%% Text Formats
\def\nameform         {\Huge\scshape}
\def\contform         {\normalsize\upshape}
\def\secheaderform    {\large\scshape}
\def\subheaderform    {\normalsize\scshape}
\def\subsubheaderform {\small\itshape}
\def\sublocationform  {\small\itshape}
\def\subdateform      {\small\upshape}
\def\listitemform     {\normalsize\upshape}

%% Spacing
\def\nameskip         {\smallskip\break}
\def\headerskip       {\smallskip\par}
\def\contsep          {\enspace\ }
\def\noiconsep        {\ \textbullet\ }

\def\secheaderskip    {\smallskip}
\def\seclineskip      {\medskip}     
\def\secendskip       {\medskip}     
\def\subheaderskip    {\vspace{0pt}} 
\def\subitemsep       {3pt}          
\def\cvitemsep        {0pt}          

\setlength{\parskip}{0pt}
\setlist{leftmargin=0pt}

%% Itemize List Settings
\setlist[itemize]{
  leftmargin=10pt,
  label=\textbullet,
  format=\listitemform,
  itemsep=\cvitemsep
}

\newenvironment*{cvsection}[1]{
    \raggedright
    {\secheaderform#1}
    \secheaderskip
    \hrule
    \seclineskip
    \begin{description}
    }{
    \end{description}
    \secendskip%
}


%% Education
%% [4]: {School} {Programme} {GPA} {Date}
\newenvironment*{cveducation}[4]{
{
    \notblank{#3}{
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subsubheaderform#3}\enspace|\enspace{\subdateform#4}
    }{
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subdateform#4}
    }
  }\subheaderskip
  \begin{itemize}
}{
  \end{itemize}
}

%% Experience
%% [4]: {Company / Organization} {Title} {Location} {Date}
\newenvironment*{cvexperience}[4]{
{
    \notblank{#3}{
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subsubheaderform#3}\enspace|\enspace{\subdateform#4}
    }{
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subdateform#4}
    }
  }\subheaderskip
  \begin{itemize}
}{
  \end{itemize}
}

%% Project
%% [2]: {Project} {Date}
\newenvironment*{cvproject}[2]{
{
    \item[\enspace{\subsubheaderform#1}]\hfill{\subdateform#2}
  }\subheaderskip
  \begin{itemize}
}{
  \end{itemize}
}

%% List
\newenvironment*{cvlist}{
    \begin{itemize}
 }{%       
    \end{itemize}
}

%% List Format Macros
\newrobustcmd*{\listitem}[1]{\listitemform\item#1}
\newrobustcmd*{\descitem}[1]{\descitemform\item#1}

%%-------------------------------
%% Cover Letter
%%-------------------------------
\newenvironment*{coverletter}{
    \clearpage
    \newgeometry{left=\coverlettermargins, right=\coverlettermargins, top=\cvmargins, bottom=\cvmargins}
    \printcvheader
    \raggedright
    \bigskip
}{
    \restoregeometry
}

\newenvironment*{contactdetails}{
    \medskip \newline 
    Best regards, \\
    \name \\
    \phone \\
    \href{mailto:\email}{\email} \\
    \ifdefined\linkedin
        LinkedIn: \href{https://\linkedin}{\linkedin} \\
    \fi
    \ifdefined\github
        GitHub: \href{https://\github}{\github} \\
    \fi
}

