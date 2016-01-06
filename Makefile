EMACS ?= emacs
CASK  ?= cask

.PHONY: test coverage

test:
	${CASK} exec ${EMACS} -Q -batch -L . -l test/caseformat-test.el \
	  -f ert-run-tests-batch-and-exit

coverage:
	${CASK} exec ${EMACS} -Q -batch -L . -l scripts/measure-coverage.el \
	  -l test/caseformat-test.el -f ert-run-tests-batch-and-exit
