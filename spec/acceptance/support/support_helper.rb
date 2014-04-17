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
end