$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "accordive_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "accordive_rails"
  s.version     = AccordiveRails::VERSION
  s.authors     = ["Jon Calhoun"]
  s.email       = ["joncalhoun@gmail.com"]
  s.homepage    = "https://www.accordive.com"
  s.summary     = "Accordive for Ruby on Rails applications."
  s.description = "Increase your support efficiency with custom CRM integrations and Admin Dashboards without needing dev work."

  s.files = Dir["{app,config,db,lib,web}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency 'sinatra'
  s.add_dependency 'jbuilder'
  s.add_dependency 'tilt-jbuilder'
end
