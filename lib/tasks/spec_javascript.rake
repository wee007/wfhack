namespace :spec do
  
  desc "Run all JavaScript specs"
  task :javascript => :environment do
    exec('rake assets:clean; guard-jasmine')
  end

end
