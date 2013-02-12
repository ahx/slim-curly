require "bundler/gem_tasks"
require 'rake/testtask'

task 'test'

Rake::TestTask.new('test') do |t|
  t.libs << 'lib' << 'test'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end
