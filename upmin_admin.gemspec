$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "upmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "upmin_admin"
  s.version     = Upmin::VERSION
  s.authors     = ["Jon Calhoun"]
  s.email       = ["dev@upmin.com"]
  s.homepage    = "https://www.upmin.com"
  s.summary     = "Quick and Easy Admin Dashboards"
  s.description = "Customizable admin dashbaords generated with only a few lines of code."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "haml", [">= 3.0.0"]
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "ransack"
end
