$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "upmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "upmin-admin"
  s.version     = Upmin::VERSION
  s.authors     = ["Jon Calhoun", "Shane Calhoun"]
  s.email       = ["support@upmin.com"]
  s.homepage    = "https://www.upmin.com/admin-rails"
  s.summary     = "Quick and Easy Admin Dashboards"
  s.description = "Customizable admin dashboards generated with only a few lines of code."
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,lib}/**/*",
    "Rakefile",
    "README.md"
  ]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "haml", [">= 3.0.0"]
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "kaminari"
  s.add_dependency "ransack"
end
