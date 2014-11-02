#!/usr/bin/env rake
# encoding: utf-8

require 'bundler/gem_tasks'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => "spec:all"

def update_files(gemfile = nil)
  # Drop and reload spec files
  sh "rm -rf spec/"
  sh "cp -R ../../spec spec"
  sh "cp ../../.rspec .rspec"

  # Copy gemfile specific specs if they exist
  if Dir.exists?("../../spec_#{gemfile}")
    sh "cp -R ../../spec_#{gemfile} spec/#{gemfile}"
  end

  # Drop and reload Upmin::Model files
  sh "rm -rf app/upmin/"
  sh "cp -R ../../test_app_upmin app/upmin"
end

namespace :spec do

  # Full bundle install & test.
  %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate data_mapper).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task "#{gemfile}" do
      Dir.chdir("test_apps/#{gemfile}")
      puts "Testing in #{`pwd`}"
      sh "bundle install --quiet"
      sh "bundle update --quiet"

      # Drop migrations and recreate
      sh "rm -rf db/migrate/*"

      if gemfile != "data_mapper"
        sh "bundle exec rake railties:install:migrations > /dev/null"
      end

      if gemfile == "active_record_32"
        sh "bundle exec rake db:drop db:create db:migrate --quiet > /dev/null"
      end

      sh "RAILS_ENV=test bundle exec rake db:drop db:create db:migrate --quiet > /dev/null"

      update_files

      # Run tests
      sh "bundle exec rake"
    end
  end

  # Use existing models & install and just rake.
  %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate data_mapper).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task "#{gemfile}_quick" do
      Dir.chdir("test_apps/#{gemfile}")
      puts "Re-testing in #{`pwd`}. Bundle install and migration updates will NOT happen!"

      update_files

      # Run tests
      sh "bundle exec rake"
    end
  end

  desc "Run Tests with namespaced models"
  task :namespaced_model do
    Dir.chdir("test_apps/namespaced_model")
    puts "Testing in #{`pwd`}"
    sh "bundle install --quiet"
    sh "bundle update --quiet"

    # Drop migrations and recreate
    sh "rm -rf db/migrate/*.test_models.rb"
    sh "bundle exec rake railties:install:migrations > /dev/null"

    sh "RAILS_ENV=test bundle exec rake db:drop db:create db:migrate db:seed --quiet > /dev/null"

    update_files("namespaced_model")

    # Run tests
    sh "bundle exec rake"
  end


  desc "Run Tests with namespaced models quickly (no bundle install etc)"
  task :namespaced_model_quick do
    Dir.chdir("test_apps/namespaced_model")
    puts "Re-Testing in #{`pwd`}. Bundle install and migration updates will NOT happen!"

    update_files("namespaced_model")

    # Run tests
    sh "bundle exec rake"
  end

  desc "Run Tests against all ORMs"
  task :all do
    %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate data_mapper namespaced_model).each do |gemfile|
      sh "rake spec:#{gemfile}"
    end
  end

  desc "Run Tests against all ORMs"
  task :all_quick do
    %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate data_mapper namespaced_model).each do |gemfile|
      sh "rake spec:#{gemfile}_quick"
    end
  end

end
