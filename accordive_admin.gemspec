$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "accordive_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "accordive_admin"
  s.version     = AccordiveAdmin::VERSION
  s.authors     = ["Jon Calhoun"]
  s.email       = ["joncalhoun@gmail.com"]
  s.homepage    = "https://www.accordive.com"
  s.summary     = "Quick and Easy Admin Dashboards"
  s.description = "Customizable admin dashbaords generated with only a few lines of code."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  # s.add_dependency "haml-rails"
end
