# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "social/version"

Gem::Specification.new do |s|
  s.name        = "social"
  s.version     = Social::VERSION
  s.authors     = ["Kazantsev Nickolay"]
  s.email       = ["kazantsev.nickolay@gmail.com"]
  s.homepage    = ''
  s.summary     = 'Social API wrapper and Tools'
  s.description = 'This is social networks api wrapper and authorization tools for social applications. 
    Now it is a compilation of code from various projects in production. Without tests. =( NOT RECOMMENDED USE IN PRODUCTION.'

  s.rubyforge_project = "social"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "rspec-core", "~> 2.0"
  s.add_development_dependency "rspec-expectations", "~> 2.0"
  s.add_development_dependency "rr", "~> 1.0"
end
