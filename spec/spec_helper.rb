require 'simplecov'
SimpleCov.start { enable_coverage :branch }

require 'bundler'
Bundler.require :default, :development

require 'redirectly/cli'

include Redirectly

RSpec.configure do |config|
  config.include Rack::Test::Methods
  
  def app
    App.new(config_path)
  end

  def host_get(url)
    host, path = url.split('/', 2)
    path = "/#{path}"
    get path, nil, { "HTTP_HOST" => host }
  end
end