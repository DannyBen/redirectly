require 'cgi'
require 'mustermann'
require 'net/http'
require 'rack'
require 'uri'

module Redirectly
  class App
    using Refinements

    attr_reader :config_path, :req

    def initialize(config_path)
      @config_path = config_path
    end

    def call(env)
      @req = Rack::Request.new env
      found = find_match

      if found
        handle_target found
      else
        not_found
      end
    end

  private

    def handle_target(target)
      if target.start_with? '@'
        proxy_to target[1..]
      else
        redirect_to target
      end
    end

    def redirect_to(target)
      code = 302

      if target.start_with? '!'
        code = 301
        target = target[1..]
      end

      [code, { 'location' => target }, []]
    end

    def proxy_to(target)
      uri = URI target
      uri.query = req.query_string unless req.query_string.empty?

      response = Net::HTTP.get_response uri

      headers = { 'Content-Type' => response['Content-Type'] }
      [response.code.to_i, headers, [response.body]]
    rescue => e
      [502, { 'Content-Type' => 'text/plain' }, ["Bad Gateway: #{e.message}"]]
    end

    def not_found
      [404, { 'content-type' => 'text/plain' }, ['Not Found']]
    end

    def redirects
      if ENV['REDIRECTLY_RELOAD']
        ini_read config_path
      else
        @redirects ||= ini_read(config_path)
      end
    end

    def ini_read(path)
      content = File.readlines(path, chomp: true).reject(&:comment?).reject(&:empty?)
      content.to_h { |line| line.split(/\s*=\s*/, 2) }
    end

    def find_match
      redirects.each do |pattern, target|
        found = find_target pattern, target
        return found if found
      end

      nil
    end

    def find_target(pattern, target)
      params = get_params pattern
      params ? composite_target(target, params) : nil
    end

    def get_params(pattern)
      pattern = "#{pattern}/" unless pattern.include? '/'
      requested = "#{req.host}#{req.path}"
      matcher = Mustermann.new pattern
      params = matcher.params requested

      if params
        params.transform_keys!(&:to_sym)
        params.delete :splat
      end

      params
    end

    def composite_target(target, params)
      result = target % params
      unless req.query_string.empty?
        glue = result.include?('?') ? '&' : '?'
        result = "#{result}#{glue}#{req.query_string}"
      end
      result
    end
  end
end
