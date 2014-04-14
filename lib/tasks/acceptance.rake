require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run all specs in spec/acceptance directory'
  RSpec::Core::RakeTask.new(:acceptance) do |task|
    task.pattern = FileList['spec/acceptance/**/*_spec.rb']
  end
end