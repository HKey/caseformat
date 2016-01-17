# caseformat

[![Build Status](https://travis-ci.org/HKey/caseformat.svg?branch=master)](https://travis-ci.org/HKey/caseformat)
[![Coverage Status](https://coveralls.io/repos/HKey/caseformat/badge.svg?branch=master&service=github)](https://coveralls.io/github/HKey/caseformat?branch=master)
[![MELPA](https://melpa.org/packages/caseformat-badge.svg)](https://melpa.org/#/caseformat)
[![MELPA Stable](https://stable.melpa.org/packages/caseformat-badge.svg)](https://stable.melpa.org/#/caseformat)

Caseformat is a format based letter case converter.

![screencast](https://raw.githubusercontent.com/HKey/caseformat-assets/master/screencast.gif)

This tool helps you to insert uppercase alphabetical characters without
shift keys.
This is inspired by [sticky](http://www.emacswiki.org/emacs/sticky.el),
[sequential-command](http://www.emacswiki.org/emacs/sequential-command.el) and
[electric-case](https://github.com/zk-phi/electric-case).

## Requirements

- Emacs 24 or later
- cl-lib
- [dash](https://github.com/magnars/dash.el)
- [s](https://github.com/magnars/s.el)

## Installation

You can install caseformat from [MELPA](https://melpa.org/#/) or
[MELPA Stable](https://stable.melpa.org/#/) by following steps:

1. Setup the Emacs built-in package manager to use MELPA or MELPA Stable.  
   MELPA's documentation is [here](https://github.com/milkypostman/melpa#usage).

2. Install caseformat.  
   `M-x package-install caseformat`

## Basic usage

1. Enable `caseformat-mode` with `M-x caseformat-mode` or `M-x global-caseformat-mode`

2. Press `M-l` after insertion of a string that you want to convert

## Mechanism of conversion

Caseformat converts prefixed alphabetical characters with converter functions.
For example, "camel-case-string" will be converted to
"camelCaseString" by `caseformat-convert`.

```emacs-lisp
(caseformat-convert "camel-case-string") ; => "camelCaseString"
```

Internally `caseformat-convert` splits an input string into prefixed strings.
Then caseformat converts them with converter functions corresponding
to prefixes and returns a concatenated string.

| prefixed string | prefix    | converter    | result |
|-----------------|-----------|--------------|--------|
| camel           | *nothing* | *nothing*    | camel  |
| -case           | "-"       | `capitalize` | Case   |
| -string         | "-"       | `capitalize` | String |

Prefixes and corresponding converters are determined by
`caseformat-converter-table`.
So only registered strings in the value of it are handled as prefixes.
The default value of it is below:

```emacs-lisp
caseformat-converter-table
;; => (("-" capitalize)
;;     (":" upcase))
```

## Versioning

The versioning of caseformat follows [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).
