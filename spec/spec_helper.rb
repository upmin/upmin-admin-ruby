$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

begin
  require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'capybara/rspec'
require 'database_cleaner'

if defined?(Rails)
  require 'test_app/rails_app'
  require 'rspec/rails'
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.after do
    if example.metadata[:type] == :feature && example.exception.present?
      save_and_open_page
    end
  end
end
