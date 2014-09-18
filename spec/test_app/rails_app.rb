# require 'rails/all'
require 'action_controller/railtie'
require 'action_view/railtie'

require 'test_app/active_record/config' if defined? ActiveRecord
require 'test_app/data_mapper/config' if defined? DataMapper
require 'test_app/mongoid/config' if defined? Mongoid
require 'test_app/mongo_mapper/config' if defined? MongoMapper

# config
app = Class.new(Rails::Application)
app.config.secret_token = 'supersecretupminadminkeytoken123'
app.config.session_store(:cookie_store, :key => '_upmin_admin_test_session')
app.config.active_support.deprecation = :log
app.config.eager_load = false
# Rais.root
app.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
app.initialize!

# routes
app.routes.draw do
  mount Upmin::Engine => "/upmin"
end

#models
if defined?(ActiveRecord)
  Dir["#{File.dirname(__FILE__)}/active_record/models/*.rb"].each {|f| require f}
  require "test_app/active_record/migrations"
else
  puts "NOT YET IMPLEMENTED"
end

# helpers
Object.const_set(:ApplicationHelper, Module.new)
