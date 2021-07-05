lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'redirectly/version'

Gem::Specification.new do |s|
  s.name        = 'redirectly'
  s.version     = Redirectly::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Redirectly redirect server"
  s.description = "Redirect server with dynamic URL and hostname support"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["redirectly"]
  s.homepage    = 'https://github.com/dannyben/redirectly'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.5.0"

  s.add_runtime_dependency 'mister_bin', '~> 0.7'
  s.add_runtime_dependency 'rack', '~> 2.2'
  s.add_runtime_dependency 'mustermann', '~> 1.1'
  s.add_runtime_dependency 'puma', '~> 5.3'
  s.add_runtime_dependency 'addressable', '~> 2.7'

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/DannyBen/redirectly/issues",
    "source_code_uri"   => "https://github.com/dannyben/redirectly",
  }
end
