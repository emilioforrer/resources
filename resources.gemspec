$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resources/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resources"
  s.version     = Resources::VERSION
  s.authors     = ["Emilio Forrer"]
  s.email       = ["dev.emilio.forrer@gmail.com"]
  s.homepage    = "https://github.com/emilioforrer/resources"
  s.summary     = "It's a gem that help's you to create CRUD controllers for your models in a very fast and flexible way."
  s.description = "It's a gem that help's you to create CRUD controllers for your models in a very fast and flexible way."
  s.license     = "MIT"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

end
