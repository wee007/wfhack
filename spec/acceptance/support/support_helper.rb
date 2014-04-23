module SupportHelper
  def with_redirecting_on
    with_redirecting true
  end
  
  def with_redirecting_off
    with_redirecting false
  end
  
  def with_redirecting(follow)
    page.driver.options[:follow_redirects] = follow
  end
  
  def log(message)
    puts "    #{message}" unless ENV['quiet']
  end
  
  def bust_cache(path)
    uri = URI path
    buster = "cache_bust=#{Time.now.to_i}"
    uri.query = uri.query ? (uri.query.split('&') << buster).join('&') : buster
    uri.to_s
  end

  def wait_for_ajax_requests
    wait_until(20) { (page.evaluate_script('typeof jQuery != "undefined" && jQuery.active == 0')) }
  end

  def wait_for_element(element)
    wait_until(20) do
      page.evaluate_script %{typeof jQuery != "undefined" && (jQuery("#{element}").length > 0)}
    end
  end

  def wait_until(timeout = Capybara.default_wait_time)
    Timeout.timeout(timeout) do
      sleep(0.1) until value = yield
      value
    end
  end
  
  def set_proxy
    if ENV['http_proxy']
      proxy = 'proxy.dbg.westfield.com'
      proxy_port = 8080
      log "Using Proxy: #{proxy}:#{proxy_port}"
      
      case Capybara.current_driver
      when :webkit, :mechanize
        Capybara.current_session.driver.browser.set_proxy :host => proxy, :port => proxy_port
      end
    end
  end
end