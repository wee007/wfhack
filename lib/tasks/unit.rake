require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run all specs in spec directory (excluding acceptance specs)'
  RSpec::Core::RakeTask.new(:unit) do |task|
    task.pattern = FileList['spec/**/*_spec.rb'].exclude("spec/acceptance/**/*_spec.rb")
  end
end