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

  def host_get(url, args = nil)
    host, path = url.split('/', 2)
    path = "/#{path}"
    get path, args, { 'HTTP_HOST' => host }
  end

  def reset_tmp_dir
    if Dir.exist? tmp_dir
      Dir["#{tmp_dir}/**/*"].each { |file| File.delete file if File.file? file }
    else
      Dir.mkdir tmp_dir
    end
  end

  def tmp_dir
    File.expand_path 'tmp', __dir__
  end
end
