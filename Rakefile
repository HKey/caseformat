require 'rake/clean'

EMACS = ENV['EMACS'] || 'emacs'
CASK = ENV['CASK'] || 'cask'

# Utilities

def byte_compile_file(el_file)
  command = %W(#{CASK} exec #{EMACS} -Q -batch -L . -f batch-byte-compile
               #{el_file})
  sh(*command)
end

# Tasks

CLEAN.include('*.elc', 'test/*.elc')

rule '.elc' => '.el' do |t|
  byte_compile_file t.source
end

desc 'Compile emacs lisp files'
task compile: ['caseformat.elc', 'test/caseformat-test.elc']

desc 'Run tests'
task :test do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l test/caseformat-test.el
       -f ert-run-tests-batch-and-exit)
  sh(*command)
end


desc 'Measure coverage'
task coverage: :clean do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l scripts/measure-coverage.el
       -l test/caseformat-test.el -f ert-run-tests-batch-and-exit)
  sh(*command)
end
