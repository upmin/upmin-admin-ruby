#!/usr/bin/env rake
# encoding: utf-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => "spec:all"

def update_files
    # Drop and reload spec files
  sh "rm -rf spec/"
  sh "cp -R ../../spec spec"
  sh "cp ../../.rspec .rspec"

  # Drop and reload Upmin::Model files
  sh "rm -rf app/upmin/"
  sh "cp -R ../../test_app_upmin app/upmin"
end

namespace :spec do
  # Full bundle install & test.
  %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task "#{gemfile}" do
      Dir.chdir("test_apps/#{gemfile}")
      puts "Testing in #{`pwd`}"
      sh "bundle install --quiet"
      sh "bundle update --quiet"

      # Drop migrations and recreate
      sh "rm -rf db/migrate/*"
      sh "bundle exec rake railties:install:migrations --quiet"

      if gemfile == "active_record_32"
        sh "bundle exec rake db:drop db:create db:migrate --quiet"
      end

      sh "RAILS_ENV=test bundle exec rake db:drop db:create db:migrate --quiet"

      update_files

      # Run tests
      sh "bundle exec rake"
    end
  end

  # Use existing models & install and just rake.
  %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task "#{gemfile}_quick" do
      Dir.chdir("test_apps/#{gemfile}")
      puts "Re-testing in #{`pwd`}. Bundle install and migration updates will NOT happen!"

      update_files

      # Run tests
      sh "bundle exec rake"
    end
  end

  desc "Run Tests against all ORMs"
  task :all do
    %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate).each do |gemfile|
      sh "rake spec:#{gemfile}"
    end
  end

  desc "Run Tests against all ORMs"
  task :all_quick do
    %w(active_record_32 active_record_40 active_record_41 active_record_42 will_paginate).each do |gemfile|
      sh "rake spec:#{gemfile}_quick"
    end
  end

end
