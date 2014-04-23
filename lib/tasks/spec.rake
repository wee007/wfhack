# require 'rspec/core/rake_task'
# 
# namespace :spec do
#   desc 'Run all specs in spec directory (excluding acceptance specs)'
#   RSpec::Core::RakeTask.new(:unit) do |task|
#     task.pattern = FileList['spec/**/*_spec.rb'].exclude("spec/acceptance/**/*_spec.rb")
#   end
#   
#   desc 'Run all specs in spec/acceptance directory'
#   RSpec::Core::RakeTask.new(:acceptance) do |task|
#     task.pattern = FileList['spec/acceptance/**/*_spec.rb']
#     task.rspec_opts = "-f documentation -r rspec_junit_formatter --format RspecJunitFormatter -o reports/junit.xml"
#   end
# end