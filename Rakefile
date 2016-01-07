EMACS = ENV['EMACS'] || 'emacs'
CASK = ENV['CASK'] || 'cask'

# Tasks

desc 'Run tests'
task :test do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l test/caseformat-test.el
       -f ert-run-tests-batch-and-exit)
  sh(*command)
end

desc 'Measure coverage'
task :coverage do
  command =
    %W(#{CASK} exec #{EMACS} -Q -batch -L . -l scripts/measure-coverage.el
       -l test/caseformat-test.el -f ert-run-tests-batch-and-exit)
  sh(*command)
end
