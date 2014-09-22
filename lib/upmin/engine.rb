# require 'haml-rails'

module Upmin
  class Engine < ::Rails::Engine
    isolate_namespace Upmin

    config.autoload_paths << "#{::Rails.root}/app/upmin/models"
  end
end
