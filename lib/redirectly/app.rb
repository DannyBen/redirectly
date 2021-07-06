require 'cgi'
require 'rack'
require 'mustermann'

module Redirectly
  class App
    using Refinements

    attr_reader :config_path, :req

    def initialize(config_path)
      @config_path = config_path
    end

    def call(env)
      @req = Rack::Request.new env
      found = match

      if found
        redirect_to found
      else
        not_found
      end
    end

  private

    def redirect_to(target)
      code = 302

      if target.start_with? '!'
        code, target = 301, target[1..-1] 
      end

      [code, {'Location' => target}, []]
    end

    def not_found
      [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end

    def redirects
      @redirects ||= ini_read(config_path)
    end

    def ini_read(path)
      content = File.readlines(path, chomp:true).reject { |line| line.comment? }
      content.map { |line| line.split(/\s*=\s*/, 2) }.to_h
    end

    def match
      redirects.each do |pattern, target|
        found = find_target pattern, target
        return found if found
      end

      nil
    end

    def find_target(pattern, target)
      params = get_params pattern, target
      params ? composite_target(target, params) : nil
    end

    def get_params(pattern, target)
      pattern = "#{pattern}/" unless pattern.include? "/" 
      requested = "#{req.host}#{req.path}"
      matcher = Mustermann.new pattern
      params = matcher.params requested
      
      if params      
        params.transform_keys! &:to_sym
        params.delete :splat
        params.transform_values! { |v| CGI.escape v }
      end

      params
    end

    def composite_target(target, params)
      result = target % params
      unless req.query_string.empty?
        glue = result.include?("?") ? "&" : "?"
        result = "#{result}#{glue}#{req.query_string}"
      end
      result
    end
  end
end
