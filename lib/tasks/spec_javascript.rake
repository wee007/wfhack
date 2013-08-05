namespace :spec do

  desc "Run all JavaScript specs"
  task :javascript => :environment do
    system("rake assets:clean; karma start config/karma.conf.js --single-run")
    exit 1 unless $?.exitstatus == 0
    system('rake assets:clean; guard-jasmine')
    exit 1 unless $?.exitstatus == 0
  end

end
