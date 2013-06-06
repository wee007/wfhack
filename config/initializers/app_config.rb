class AppConfig < Settingslogic

  #:nocov:
  ConfigFilePath = 'config/appconfig.yml'
  OverrideConfigFilePath = '/etc/westfield/customerconsole/appconfig.yml'

  source Rails.root.join ConfigFilePath

  namespace Rails.env

  if File.exists? OverrideConfigFilePath
    instance.deep_merge! Settingslogic.new OverrideConfigFilePath
  end

  def merge! hash
    super hash.stringify_keys!
  end
  #:nocov:

end

