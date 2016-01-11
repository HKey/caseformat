;;; -*- lexical-binding: t; -*-

;; External cl-lib package causes byte compilation warnings
(when (version<= "24.3" emacs-version)
  (setq byte-compile-error-on-warn t))
