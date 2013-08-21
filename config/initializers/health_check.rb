HealthCheck.setup do |config|
  config.success = 'success'
  config.http_status_for_error_text = 500
  config.http_status_for_error_object = 500

  config.add_custom_check do
    AaaClient::RedisHealthCheck.new(WestfieldUri::Redis.uri_for).error_messages
  end
end
