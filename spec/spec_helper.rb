ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'factory_girl_rails'
require 'database_cleaner'

# Active Record Models, Table, and Seeder
if defined?(ActiveRecord) || true
  require 'setups/active_record/migrate/all_tables'
  require 'setups/active_record/test_data/seeder'
  Dir["#{File.dirname(__FILE__)}/setups/models/**/*.rb"].each { |f| require f }
end


Rails.backtrace_cleaner.remove_silencers!


# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) do
    AllTables.up
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Seeder.seed
  end

  config.after(:suite) do
    AllTables.down
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
