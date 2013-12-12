namespace :spec do

  desc "Run all JavaScript specs"
  task :javascript => :environment do
    Rake::Task["spec:karma"].invoke
    Rake::Task["spec:jasmine"].invoke
  end

  desc "Run all Karma specs"
  task :karma => :environment do
    system("rake assets:clean; karma start config/karma.conf.js --single-run")
    exit 1 unless $?.exitstatus == 0
  end

  desc "Run all Jasmine specs"
  task :jasmine => :environment do
    system('rake assets:clean; guard-jasmine')
    exit 1 unless $?.exitstatus == 0
  end

end
