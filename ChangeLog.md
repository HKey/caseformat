# caseformat ChangeLog

## 0.2.0

[Commits](https://github.com/HKey/caseformat/compare/0.1.0...master)

- Made `global-caseformat-mode` selectable. ([#7](https://github.com/HKey/caseformat/pull/7))  
  You can disable `caseformat-mode` in specified buffers when using
  `global-caseformat-mode`.  
  For example, if you want to disable `caseformat-mode` in the minibuffer,
  please set `caseformat-global-mode-selector` like below:

  ```emacs-lisp
  (setq caseformat-global-mode-selector (lambda () (not (minibufferp))))
  ```

- Added ability to repeat like [sequential-command](http://www.emacswiki.org/emacs/sequential-command.el). ([#10](https://github.com/HKey/caseformat/pull/10))  
  This is enabled by default.
  If you want to disable this, set `caseformat-enable-repetition` to `nil`.

- Added an option to set a converter function for a no-prefix string and
  added `downcase` as it to `caseformat-converter-table`. ([#11](https://github.com/HKey/caseformat/pull/11))  
  So now caseformat converts a no-prefix string, e.g. "FOOBAR",
  using `downcase` by default.

## 0.1.0

- First release
