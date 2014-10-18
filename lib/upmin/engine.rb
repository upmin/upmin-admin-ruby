# require 'haml-rails'
# require kaminari here to affect load order so that custom kaminari views load from upmin
require 'kaminari'

module Upmin
  class Engine < ::Rails::Engine
    isolate_namespace Upmin

    config.autoload_paths << "#{::Rails.root}/app/upmin/models"
  end
end
