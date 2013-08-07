worker_processes ( [ENV["UNICORN_WORKERS"].to_i, 4].max )
timeout ([ENV["UNICORN_TIMEOUT"].to_i, 15].max )
preload_app (ENV["UNICORN_PRELOAD_APP"] == "true")

before_fork do |server, worker|
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info "Disconnected from ActiveRecord"
  end
  sleep 1
end

after_fork do |server, worker|
  if defined? ActiveRecord::Base
    ActiveRecord::Base.establish_connection
    Rails.logger.info "Connected to ActiveRecord"
  end

  if defined? Redis
    Redis.current.quit
  end
end
