ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'database_cleaner'
require 'factory_girl_rails'


if defined?(ActiveRecord) || defined?(DataMapper)
  require File.expand_path('../../../../test_seeders/seeder', __FILE__)
end


RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.order = "random"

  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    if defined?(DataMapper)
      DataMapper.finalize
      DataMapper.auto_migrate!
    end

    Seeder.seed
  end

  config.after(:suite) do
  end

  config.before(:each) do
  end

  config.after(:each) do
  end

  # Uncomment this if you want to the page to be saved and opened after any test failure.
  # config.after do |example|
  #   if example.metadata[:type] == :feature && example.exception.present?
  #     save_and_open_page
  #   end
  # end

  config.include(FactoryGirl::Syntax::Methods)
  config.include(ActionView::Helpers::NumberHelper, type: :view)
end
