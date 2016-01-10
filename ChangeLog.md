# caseformat ChangeLog

## 0.2.0

[Commits](https://github.com/HKey/caseformat/compare/0.1.0...master)

- Made `global-caseformat-mode` selectable.  
  You can disable `caseformat-mode` in specified buffers when using
  `global-caseformat-mode`.  
  For example, if you want to disable `caseformat-mode` in the minibuffer,
  please set `caseformat-global-mode-selector` like below:

  ```emacs-lisp
  (setq caseformat-global-mode-selector (lambda () (not (minibufferp))))
  ```

## 0.1.0

- First release
