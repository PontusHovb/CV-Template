\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv_template}[2021/08/06 Resume Template]

\usepackage{soul}
\usepackage{import}

\RequirePackage{xkeyval} % key-value macros
\RequirePackage{etoolbox} % robust commands, macros, booleans, tests

%% Options
\newbool{iconbool}
\newbool{fitbool}
\newbool{framebool}
\DeclareOptionX{marg}[0.5in]{\def\@marg{margin=#1}}
\DeclareOptionX{fstyle}[cormorantgaramond]{\def\@fstyle{#1}}
\DeclareOptionX{link}[true]{\def\@link{ocgcolorlinks=#1}}
\DeclareOptionX{icon}[true]{\setbool{iconbool}{#1}}
\DeclareOptionX{fit}[true]{\setbool{fitbool}{#1}}
\DeclareOptionX{frame}[true]{\setbool{framebool}{#1}}

%% Default Options
\ExecuteOptionsX{
  marg=0.4in,
  fstyle=cormorantgaramond,
  link=false,
  icon=false,
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
\RequirePackage{fontawesome5} % icons and logos
\RequirePackage[nomessages]{fp} % fixed point arithmetic
\RequirePackage[empty]{fullpage} % suppresses page numbers and headers/footersm
\RequirePackage[parfill]{parskip} % removes paragraph indent and sets spacing
\RequirePackage[svgnames]{xcolor} % text colors and color names
\RequirePackage[\@marg]{geometry} % set page margins
\RequirePackage[\@link]{hyperref} % web links and pdf configuration
\RequirePackage{lipsum}
%%--------------------------------------------------------------------
%%  CONSTANTS
%%----------------------------------------------------------

\def\norms{\normalsize}

%% Text Formats
\def\nameform         {\huge\scshape}
\def\contform         {\norms\upshape}

\def\secheaderform    {\large\scshape}
\def\subheaderform    {\norms\scshape}
\def\subsubheaderform {\small\itshape}
\def\subdateform      {\small\upshape}
\def\sublocationform  {\small\itshape}
\def\listitemform     {\norms\upshape}
\def\descitemform     {\small\upshape}

%% Spacing
\def\nameskip         {\smallskip\break}
\def\headerskip       {\smallskip\par}
\def\contsep          {\enspace\ }
\def\noiconsep        {\ \textbullet\ }

\def\secheaderskip    {\smallskip}   % after section header
\def\seclineskip      {\medskip}     % after section line
\def\secendskip       {\medskip}     % after sections
\def\subheaderskip    {\vspace{0pt}} % after subsection headers
\def\subitemsep       {1pt}          % between subsections
\def\cvitemsep        {0pt}          % between list items

%% Icon
\def\addressicon      {\raisebox{-0.1\height}{\faMapMarker*}\ }
\def\phoneicon        {\raisebox{-0.1\height}{\faPhone*}\ }
\def\emailicon        {\raisebox{-0.1\height}{\faEnvelope}\ }
\def\linkedinicon     {\raisebox{-0.1\height}{\faLinkedin}\ }

%%--------------------------------------------------------------------
%%  DOCUMENT CONFIGURATION
%%----------------------------------------------------------

%% Set Font Face
\setmainfont{\@fstyle}

% Paragraph Spacing
\setlength{\parskip}{0pt}

%% All List Settings
\setlist{%
  leftmargin=0pt,%
}

%% Description List Settings
\setlist[description]{%
  itemsep=\subitemsep%
}

%% Itemize List Settings
\setlist[itemize]{%
  leftmargin=10pt,%
  label=\textbullet,%
  format=\listitemform,%
  itemsep=\cvitemsep%
}

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

%%--------------------------------------------------------------------
%%  AUTO-SIZE PAGE FUNCTION
%%----------------------------------------------------------

\newsavebox\cvbox
\newcount\cvboxwidth
\newcount\cvboxheight
\environbodyname\cvbody
\newlength\currwidth
\newlength\currheight
\newlength\incrwidth
\newcounter{iter}

\ExplSyntaxOn
  \DeclareExpandableDocumentCommand{\pttoin}{m}
    {\dim_to_decimal_in_unit:nn{#1}{1in}in}
\ExplSyntaxOff

\newrobustcmd*{\logaspect}[1]{
  \stepcounter{iter}%
  \typeout{%
    #1 ITER = \theiter^^J%
    ORIG_ASPCT = \origaspect^^J%
    CURR_ASPCT = \curraspect^^J%
    INCR_WIDTH = \pttoin{\incrwidth}^^J%
    __________ = \the\incrwidth^^J%
    TEXT_WIDTH = \pttoin{\textwidth}^^J%
    __________ = \the\textwidth^^J%
    TEXT_HIGHT = \pttoin{\textheight}^^J%
    __________ = \the\textheight^^J%
    CURR_BWDTH = \pttoin{\wd\cvbox}^^J%
    __________ = \the\wd\cvbox^^J%
    NEXT_WIDTH = \pttoin{\currwidth}^^J%
    __________ = \the\currwidth^^J%
    CURR_BHGHT = \pttoin{\ht\cvbox}^^J%
    __________ = \the\ht\cvbox^^J%
    CURR_HIGHT = \pttoin{\currheight}^^J%
    __________ = \the\currheight^^J%
  }%
}%

%% Resume Format Environment
%% applies scaling from \fitaspect to entire resume
\NewEnviron{cv}{%
  \ifbool{fitbool}{%
    \setlength{\fboxsep}{-\fboxrule}
    \setlength{\currwidth}{\textwidth}
    \setlength{\currheight}{\textheight}
    \setlength{\incrwidth}{0.01\textwidth}
    \sbox{\cvbox}{\rule{\textwidth}{\textheight}}%
    \findaspect{\cvbox}%
    \edef\origaspect{\curraspect}%
    \fitaspect{\cvbody}{\origaspect}{\currwidth}%
  }{%
    \cvbody%s
  }
}

%% Find Aspect Ratio
\newrobustcmd*{\findaspect}[1]{%
  \cvboxwidth=\wd#1\relax%
  \cvboxheight=\ht#1\relax%
  \FPdiv\curraspect{\the\cvboxwidth}{\the\cvboxheight}%
}

%% Fit Text to Original Aspect Ratio
%% scales text to textwidth and textheight defined through margins
%% [3]: {targText} {origAspect} {currWidth}
\newrobustcmd*{\fitaspect}[3]{%
  \sbox{\cvbox}{\fbox{\parbox[b]{#3}{#1}}}%
  \findaspect{\cvbox}%
  \setlength{\currheight}{\the\ht\cvbox}%
  \FPiflt\curraspect{#2}% aspect ratio not met, incr width and recall
    \addtolength{#3}{\incrwidth}\logaspect{NOT_MET}%
    \fitaspect{#1}{#2}{#3}%
  \else% aspect ratio met, create box
    \logaspect{MET}%
    \ifbool{framebool}{%
      \framebox[#2\textheight]{%
        \hfil{\scaleto[#2\textheight]{\parbox[t]{#3}{#1}}{\currheight}}\hfil
      }%
    }{%
      \makebox[#2\textheight]{%
        \hfil{\scaleto[#2\textheight]{\parbox[t]{#3}{#1}}{\currheight}}\hfil
      }%
    }
  \fi%
}

%%--------------------------------------------------------------------
%%  HEADER
%%----------------------------------------------------------

%% Print Contact
%% [4]: [linkOption] {contItem} {contIcon} {contSep}
\newrobustcmd*{\cvcontact}[4][]{%
  \ifblank{#2}{}{%
    \ifbool{iconbool}{}{%
      \def\contsep{\noiconsep}%
      \def#3{}%
    }%
    \ifblank{#1}{%
      \mbox{\contform{#3#2}}#4%
    }{%
      \IfSubStringInString{@}{#3}{%
        \mbox{\contform{#3\href{mailto:#2}{#2}}}#4%
      }{%
        \mbox{\contform{#3\href{https://#2}{#2}}}#4%
      }%
    }%
  }%
}

%% Print Header
%% [4]: {<name>} {<phone>} {<email>}{<linkedIn>}
\newrobustcmd*{\cvheader}[4]{%
  {\centering%
    {\nameform#1}\nameskip%
    \cvcontact{#2}{\phoneicon}{\contsep}%
    \cvcontact[l]{#3}{\emailicon}{\contsep}%
    \cvcontact[l]{#4}{\linkedinicon}{}%
    \headerskip%
  }%
}


%%--------------------------------------------------------------------
%% SECTION
%%----------------------------------------------------------

%% Section Environment
%% defines section environment, contains formatted subsections and resume items
%% [1]: {sectionName}
\newenvironment*{cvsection}[1]{%
  {\secheaderform#1}%
  \secheaderskip%
  \hrule%
  \seclineskip%
  \begin{description}%
    }{%
  \end{description}%
  \secendskip%
}

%%--------------------------------------------------------------------
%% SUBSECTION
%%----------------------------------------------------------

%% Subsection Environment
%% defines subsection environment, contains formatted subheaders and resumeitems
%% [3]: {subHeader} {subSubHeader} {subDate}
\newenvironment*{cvsubsection}[4]{%
{%
    \item[\subheaderform#1]|\enspace{\subheaderform#2}\hfill{\subsubheaderform#3}\enspace|\enspace{\subdateform#4}%
  }\subheaderskip%
  \begin{itemize}%
}{%
  \end{itemize}%
}

%% Subsection Environment
%% defines subsection environment, contains formatted subheaders and resumeitems
%% [4]: {School} {Education} {GPA} {Date}
\newenvironment*{cveducation}[4]{%
{%
    \notblank{#3}{%
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subsubheaderform#3}\enspace|\enspace{\subdateform#4}%
    }{
    \item[\subheaderform#1]|\enspace{\subsubheaderform#2}\hfill{\subdateform#4}%
    }
  }\subheaderskip%
  \begin{itemize}%
}{%
  \end{itemize}%
}

%% List
\newenvironment*{cvlist}[0]{
    \begin{itemize}
 }{%       
    \end{itemize}
}

%%--------------------------------------------------------------------
%% LIST ITEMS
%%----------------------------------------------------------

%% List Format Macros
\newrobustcmd*{\listitem}[1]{\listitemform\item#1}
\newrobustcmd*{\descitem}[1]{\descitemform\item#1}