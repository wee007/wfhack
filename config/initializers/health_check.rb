HealthCheck.setup do |config|
  config.success = 'success'
  config.http_status_for_error_text = 500
  config.http_status_for_error_object = 500
end
