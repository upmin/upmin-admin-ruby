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
  s.description = "Customizable admin dashbaords generated with only a few lines of code."
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,lib}/**/*",
    "Rakefile",
    "README.md"
  ]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "haml", [">= 3.0.0"]
  s.add_dependency "jquery-rails", [">= 0"]
  s.add_dependency "sass-rails", [">= 0"]
  s.add_dependency "kaminari", [">= 0"]
  s.add_dependency "ransack", [">= 0"]

  s.add_development_dependency "bundler", [">= 0"]
  s.add_development_dependency "rake", [">= 0"]
  s.add_development_dependency "rspec", [">= 0"]
  s.add_development_dependency "capybara", [">= 0"]
  s.add_development_dependency "launchy", [">= 0"]
  s.add_development_dependency "database_cleaner", ['>= 0']

end
