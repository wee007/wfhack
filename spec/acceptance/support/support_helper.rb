module SupportHelper
  def redirecting_on
    set_redirecting true
  end

  def redirecting_off
    set_redirecting false
  end

  def set_redirecting(follow)
    (page.driver.options[:follow_redirects] = follow) rescue nil # some drivers don't have options
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

  def expect_urls_to_match(first, second)
    expect(clean_url(first)).to eql(clean_url(second))
  end

  def clean_url(url)
    URI.decode(url).gsub(/\/$/, '')
  end

  # Capybara driver related
  def set_driver(driver)
    Capybara.current_driver = driver
    set_driver_config
  end

  def set_driver_config
    set_proxy
    set_ssl_verify
  end

  def set_proxy
    if ENV['http_proxy'] || ! ENV['http_proxy'].blank?
      if !@proxy
        @proxy = URI(ENV['http_proxy'])
        log "Using Proxy: #{@proxy.host}:#{@proxy.port}"
      end
      case Capybara.current_driver
      when :webkit
        Capybara.current_session.driver.browser.set_proxy :host => @proxy.host, :port => @proxy.port
      when :mechanize
        # mechanize picks up the http_proxy env var, so we don't have to do anything here
      end
    end
  end

  def set_ssl_verify
    case Capybara.current_driver
    when :mechanize
      Capybara.current_session.driver.browser.agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def destructive name=nil, &block
    if Rails.env.production?
      location = example.metadata[:description_args].first rescue 'unknown'
      name = name ? "\"#{name}\" within \"#{location}\"" : "\"#{location}\""
      log "Skipping destructive test: #{name}"
    else
      instance_eval &block if block_given?
    end
  end

  def set_redirecting(follow)
    (page.driver.options[:follow_redirects] = follow) rescue nil # some drivers don't have options
  end

  def redirecting_on
    set_redirecting true
  end

  def redirecting_off
    set_redirecting false
  end

  def random(selector, opts={})
    items = page.all(selector, opts)
    items[rand(items.size)]
  end
end