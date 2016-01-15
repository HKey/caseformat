;;; caseformat-test.el --- Test for caseformat.el    -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Hiroki YAMAKAWA

;; Author: Hiroki YAMAKAWA <s06139@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'ert)
(require 'dash)
(require 'caseformat)


(defvar caseformat-test--cursor-indicator "`|'")

(defun caseformat-test--goto-cursor-indicator ()
  "Move the cursor to `caseformat-test--cursor-indicator'."
  (goto-char (point-min))
  (save-match-data
    (when (re-search-forward (regexp-quote caseformat-test--cursor-indicator))
      (replace-match ""))))

(defun caseformat-test--setup-in-buffer (contents)
  "Insert CONTENTS into the current buffer and move the cursor."
  (goto-char (point-min))
  (insert contents)
  (caseformat-test--goto-cursor-indicator))

(defun caseformat-test--get-contents-and-position ()
  "Return a list made of a buffer string and a cursor position."
  (list (buffer-substring-no-properties (point-min) (point-max))
        (point)))

(defun caseformat-test-should-with-temp-buffer (action
                                                init-contents
                                                expected-contents)
  "Test helper for buffers.
This calls `should' to check that the result of doing ACTION in a temporary
buffer inserted INIT-CONTENTS equals EXPECTED-CONTENTS.
ACTION is a function.
INIT-CONTENTS and EXPECTED-CONTENTS are strings.

This function compares the buffer strings and the cursor positions of
the result buffer and EXPECTED-CONTENTS buffer.
To indicate the cursor position, use the value of
`caseformat-test--cursor-indicator'."
  (let (result expected)
    (with-temp-buffer
      (caseformat-test--setup-in-buffer init-contents)
      (funcall action)
      (setq result (caseformat-test--get-contents-and-position)))
    (with-temp-buffer
      (caseformat-test--setup-in-buffer expected-contents)
      (setq expected (caseformat-test--get-contents-and-position)))
    (-let* (((rs rp) result)
            ((es ep) expected))
      (should (equal rs es))
      (should (= rp ep)))))

(defun caseformat-test-with-global-mode (action)
  "Run ACTION with context that `global-caseformat-mode' is enabled.
ACTION is a function."
  (global-caseformat-mode 1)
  (funcall action)
  (global-caseformat-mode 0))


(ert-deftest caseformat-test-convert ()
  (should (equal (caseformat-convert "foo") "foo"))
  (should (equal (caseformat-convert "-foo") "Foo"))
  (should (equal (caseformat-convert "foo-bar:baz") "fooBarBAZ"))
  (should (equal (caseformat-convert "---foo:") "--Foo:"))

  ;; no prefix tests
  (let ((caseformat-converter-table '(("-" capitalize) (t downcase))))
    ;; a prefix
    (should (equal (caseformat-convert "FOO-BAR") "FOOBar"))
    ;; no prefix
    (should (equal (caseformat-convert "FOO_BAR") "foo_bar")))
  (let ((caseformat-converter-table '((t downcase))))
    (should (equal (caseformat-convert "FOO-BAR") "foo-bar"))))

(ert-deftest caseformat-test-commands ()
  (caseformat-test-should-with-temp-buffer
   #'caseformat-forward
   "`|'-foo :bar"
   "`|'Foo :bar")
  (caseformat-test-should-with-temp-buffer
   #'caseformat-backward
   "-foo :bar`|'"
   "-foo BAR`|'")
  (caseformat-test-should-with-temp-buffer
   (lambda () (caseformat-forward 2))
   "`|'-foo :bar"
   "`|'Foo BAR")
  (caseformat-test-should-with-temp-buffer
   (lambda () (caseformat-backward 2))
   "-foo :bar`|'"
   "Foo BAR`|'"))

(ert-deftest caseformat-test-global-mode-selector ()
  (let ((ruby-buffer (get-buffer-create "*caseformat-test ruby*"))
        (lisp-buffer (get-buffer-create "*caseformat-test lisp*")))
    (with-current-buffer ruby-buffer (ruby-mode))
    (with-current-buffer lisp-buffer (lisp-mode))

    ;; check the result of `caseformat-global-mode-selector'
    (let ((caseformat-global-mode-selector
           (lambda () (not (eq major-mode 'lisp-mode)))))
      ;; prevent "Unused lexical variable" warning
      caseformat-global-mode-selector

      (caseformat-test-with-global-mode
       (lambda ()
         (with-current-buffer ruby-buffer
           (should caseformat-mode))
         (with-current-buffer lisp-buffer
           (should-not caseformat-mode)))))

    ;; always enable `global-caseformat-mode'
    (let ((caseformat-global-mode-selector nil))
      ;; prevent "Unused lexical variable" warning
      caseformat-global-mode-selector

      (caseformat-test-with-global-mode
       (lambda ()
         (with-current-buffer ruby-buffer
           (should caseformat-mode))
         (with-current-buffer lisp-buffer
           (should caseformat-mode)))))))

(ert-deftest caseformat-test-enable-repetition ()
  ;; This test does not success when called by `ert-run-tests-interactively'.
  (let ((forward-test
         (lambda ()
           (cl-dotimes (_ 2)
             (call-interactively #'caseformat-forward t))))
        (backward-test
         (lambda ()
           (cl-dotimes (_ 2)
             (call-interactively #'caseformat-backward t))))
        (caseformat-converter-table '(("-" capitalize) (":" upcase))))
    (let ((caseformat-enable-repetition nil))
      ;; disable repetition
      (caseformat-test-should-with-temp-buffer
       forward-test
       "`|'-foo :bar"
       "`|'Foo :bar")
      (caseformat-test-should-with-temp-buffer
       backward-test
       "-foo :bar`|'"
       "-foo BAR`|'"))
    (let ((caseformat-enable-repetition t))
      ;; enable repetition
      (caseformat-test-should-with-temp-buffer
       forward-test
       "`|'-foo :bar"
       "`|'Foo BAR")
      (caseformat-test-should-with-temp-buffer
       backward-test
       "-foo :bar`|'"
       "Foo BAR`|'"))))

(provide 'caseformat-test)
;;; caseformat-test.el ends here
