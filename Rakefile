# # begin
# #   require 'bundler/setup'
# # rescue LoadError
# #   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# # end

# # APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
# # load 'rails/tasks/engine.rake'

# # Bundler::GemHelper.install_tasks

# # Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

# # require 'rspec/core'
# # require 'rspec/core/rake_task'

# # RSpec::Core::RakeTask.new(:spec) do |spec|
# #   spec.pattern = FileList['spec/**/*_spec.rb']
# # end

# # task :default => "spec:all"

# # namespace :spec do
# #   %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
# #     desc "Run Tests against #{gemfile}"
# #     task gemfile do
# #       sh "cat gemfiles/#{gemfile}.gemfile"
# #       sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
# #       sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
# #     end
# #   end

# #   desc "Run Tests against all ORMs"
# #   task :all do
# #     %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
# #       sh "cat gemfiles/#{gemfile}.gemfile"
# #       sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
# #       sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake spec"
# #     end
# #   end
# # end


# #!/usr/bin/env rake
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end

# APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
# load 'rails/tasks/engine.rake'

# Bundler::GemHelper.install_tasks
# Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
# require 'rspec/core'
# require 'rspec/core/rake_task'
# desc "Run all specs in spec directory (excluding plugin specs)"
# RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
# task :default => :spec



# namespace :spec do
#   task :jon do
#     sh "BUNDLE_GEMFILE='gemfiles/active_record_40.gemfile' bundle install --quiet"
#     sh "BUNDLE_GEMFILE='gemfiles/active_record_40.gemfile' bundle exec rake -t spec"
#   end
#   # %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
#   #   desc "Run Tests against #{gemfile}"
#   #   task gemfile do
#   #     sh "cat gemfiles/#{gemfile}.gemfile"
#   #     sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
#   #     sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
#   #   end
#   # end

#   # desc "Run Tests against all ORMs"
#   # task :all do
#   #   %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
#   #     sh "cat gemfiles/#{gemfile}.gemfile"
#   #     sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
#   #     sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake spec"
#   #   end
#   # end
# end




#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
Bundler::GemHelper.install_tasks
Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
require 'rspec/core'
require 'rspec/core/rake_task'
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec

namespace :spec do
  %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake RAILS_ENV=test spec"
    end
  end

  desc "Run Tests against all ORMs"
  task :all do
    %w(active_record_42 active_record_41 active_record_40 active_record_32 will_paginate).each do |gemfile|
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake RAILS_ENV=test spec"
    end
  end
end
