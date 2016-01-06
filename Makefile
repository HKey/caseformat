EMACS ?= emacs
CASK  ?= cask

.PHONY: test

test:
	${CASK} exec ${EMACS} -Q -batch -L . -l test/caseformat-test.el \
	  -f ert-run-tests-batch-and-exit
