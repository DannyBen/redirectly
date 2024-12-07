lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redirectly/version'

Gem::Specification.new do |s|
  s.name        = 'redirectly'
  s.version     = Redirectly::VERSION
  s.summary     = 'Redirectly redirect server'
  s.description = 'Redirect server with dynamic URL and hostname support'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['redirectly']
  s.homepage    = 'https://github.com/dannyben/redirectly'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'mister_bin', '~> 0.7'
  s.add_dependency 'mustermann', '>= 1.1', '< 4'
  s.add_dependency 'puma', '>= 5.3', '< 7'
  s.add_dependency 'rack', '~> 3.0'
  s.add_dependency 'rackup', '~> 2.1'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/redirectly/issues',
    'source_code_uri'       => 'https://github.com/dannyben/redirectly',
    'rubygems_mfa_required' => 'true',
  }
end
