$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jetty_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jetty_admin"
  s.version     = JettyAdmin::VERSION
  s.authors     = ["Jon Calhoun"]
  s.email       = ["joncalhoun@gmail.com"]
  s.homepage    = "https://www.usejetty.com"
  s.summary     = "Quick and Easy Admin Dashboards"
  s.description = "Customizable admin dashbaords generated with only a few lines of code."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "typhoeus"
  s.add_dependency "haml", [">= 3.0.0"]
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"
end
