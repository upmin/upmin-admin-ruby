#!/usr/bin/env rake
# encoding: utf-8

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), "tasks/**/*.rake")].each {|f| load f }

require "rspec/core"
require "rspec/core/rake_task"

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

task :default => "spec:all"

namespace :spec do
  %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task gemfile do
      prefix = "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' RAILS_ENV=test"
      sh "#{prefix} bundle install --quiet"
      sh "#{prefix} bundle exec rake spec"
    end
  end

  desc "Run Tests against Postgresql"
  task :postgresql do
    prefix = "TEST_DB=postgresql BUNDLE_GEMFILE='gemfiles/postgresql.gemfile' RAILS_ENV=test"
    sh "#{prefix} bundle install --quiet"
    sh "#{prefix} bundle exec rake db:drop db:create"
    sh "#{prefix} bundle exec rake spec"
    sh "#{prefix} bundle exec rake db:drop"
  end

  desc "Run Tests against all ORMs"
  task :all do
    %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate postgresql).each do |gemfile|
      sh "rake spec:#{gemfile}"
    end
  end
end
