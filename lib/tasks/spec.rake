require 'rspec/core/rake_task'

task(:spec).clear
desc 'Run all specs in spec directory (excluding acceptance specs)'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList['spec/**/*_spec.rb'].exclude("spec/acceptance/**/*_spec.rb")
end

namespace :spec do
  task(:acceptance).clear
  desc 'Run all specs in spec/acceptance directory (specify desired env with RAILS_ENV=xxx, defaults to development)'
  RSpec::Core::RakeTask.new(:acceptance) do |task|
    task.pattern = FileList['spec/acceptance/**/*_spec.rb'].exclude("spec/acceptance/smoke_spec.rb")
    task.rspec_opts = "-f documentation -r rspec_junit_formatter --format RspecJunitFormatter -o reports/junit.xml"
  end
  
  desc 'Run acceptance smoke tests (specify desired env with RAILS_ENV=xxx, defaults to development)'
  RSpec::Core::RakeTask.new('acceptance:smoke') do |task|
    task.pattern = FileList['spec/acceptance/smoke_spec.rb']
    task.rspec_opts = "-f documentation -r rspec_junit_formatter --format RspecJunitFormatter -o reports/junit.xml"
  end
end