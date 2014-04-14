require 'rspec/core/rake_task'

namespace :acceptance do
  rspec_opts = "--color --format documentation --format RspecJunitFormatter -o reports/junit.xml"
  task_help = '(options: RAILS_ENV=uat)'

  desc "Acceptance tests for Trading Hours Service, #{task_help}"
  RSpec::Core::RakeTask.new(:trading_hours) do |task|
    task.pattern = 'spec/acceptance/trading_hours_spec.rb'
    task.rspec_opts = rspec_opts
  end
  
  desc "All acceptance tests, #{task_help}"
  task :all => [:trading_hours]
end