require 'rake/clean'

EMACS = ENV['EMACS'] || 'emacs'
CASK = ENV['CASK'] || 'cask'

COMPILATION_TARGETS = FileList['*.el', 'test/*.el']

# Utilities

def byte_compile_file(el_file, error_on_warn = false)
  command = %W(#{CASK} exec #{EMACS} -Q -batch -L .)
  command.concat(%w(-l scripts/setup-error-on-warn.el)) if error_on_warn
  command.concat(%W(-f batch-byte-compile #{el_file}))
  sh(*command)
end

# Tasks

CLEAN.include(COMPILATION_TARGETS.ext('.elc'))

rule '.elc' => '.el' do |t|
  byte_compile_file t.source
end

desc 'Compile emacs lisp files'
task compile: COMPILATION_TARGETS.ext('.elc')

desc 'Run tests'
task :test do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l test/caseformat-test.el
       -f ert-run-tests-batch-and-exit)
  sh(*command)
end

desc 'Run tests with .el files'
task raw_test: [:clean, :test]

desc 'Run tests with .elc files'
task compiled_test: :compile do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l test/caseformat-test.elc
       -f ert-run-tests-batch-and-exit)
  sh(*command)
end

desc 'Run compilation test'
task compilation_test: :clean do
  byte_compile_file 'caseformat.el', true
  COMPILATION_TARGETS.exclude('caseformat.el').each do |el_file|
    byte_compile_file el_file
  end
end

desc 'Run all tests'
task test_all: [:raw_test, :compilation_test, :compiled_test]

desc 'Measure coverage'
task coverage: :clean do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l scripts/measure-coverage.el
       -l test/caseformat-test.el -f ert-run-tests-batch-and-exit)
  sh(*command)
end
