require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module CustomerConsole
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.middleware.use Rack::Pjax

    config.assets.precompile += %w(old-ie.css vendor/modernizr.min.js
                                   map/micello_ie.js map/micello.js
                                   init/enquire.js enquire/dist/enquire.js
                                   flexslider/jquery.flexslider.js
                                   flexslider/flexslider.css
                                   html5shiv/src/html5shiv-printshiv.js
                                   stores_maps.js
                                   jquery-extensions/jquery.toggle-content.js
                                   server_errors.css
                                   init/sort_centres_by_geolocation.js
                                   search/load_products.js
                                   prism/prism.js
                                   prism/prism.css
                                   styleguide/styleguide.css
                                   vendor/kss.js
                                   support/placeholder-init.js
                                   )
    if Rails.env.development?
      require File.expand_path('../../lib/service_proxy', __FILE__)
      config.middleware.use "ServiceProxy"
    end

  end
end
