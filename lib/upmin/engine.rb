# require kaminari here to affect load order so that custom Kaminari (bootstrap) views load from upmin,
# unless will_paginate is used in the parent Rails app.
require 'kaminari' unless defined?(WillPaginate)

module Upmin
  class Engine < ::Rails::Engine
    isolate_namespace Upmin

    config.autoload_paths << "#{::Rails.root}/app/upmin/models"
  end
end

