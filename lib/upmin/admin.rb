require "upmin"
require "upmin/engine"

require "upmin/automatic_delegation"
require "upmin/configuration"
require "upmin/errors"
require "upmin/paginator"

require "upmin/model"
require "upmin/attribute"
require "upmin/attribute_value"
require "upmin/association"
require "upmin/action"
require "upmin/parameter"
require "upmin/query"

# ActiveRecord Specifics.
if defined?(ActiveRecord)
  Dir["#{File.dirname(__FILE__)}/active_record/**/*.rb"].each { |f| require f }
end

# DataMapper Specifics
if defined?(DataMapper)
  Dir["#{File.dirname(__FILE__)}/data_mapper/**/*.rb"].each { |f| require f }
end

# Monkey patch code into rails
require "upmin/railties/data_mapper"
require "upmin/railties/active_record"
require "upmin/railties/paginator"
require "upmin/railties/render"
require "upmin/railties/render_helpers"
require "upmin/railtie"

# gems and stuff we use
require "jquery-rails"
require "ransack"
require "haml"
require "sass-rails"


require "ostruct"

# If WillPaginate is present we just use it, but by default upmin-admin uses Kaminari
require "kaminari" unless defined?(WillPaginate)

require 'rails'

module Upmin
  module Admin
  end
end

