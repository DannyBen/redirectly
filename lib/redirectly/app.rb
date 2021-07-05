require 'cgi'
require 'rack'
require 'mustermann'

module Redirectly
  class App
    using Refinements

    attr_reader :config_path

    def initialize(config_path)
      @config_path = config_path
    end

    def call(env)
      req = Rack::Request.new(env)
      found = match req

      if found
        if found.start_with? '!'
          code, target = 301, found[1..-1] 
        else
          code, target = 302, found
        end
        
        [code, {'Location' => target}, []]
      
      else
        [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
      
      end
    end

  private

    def redirects
      @redirects ||= ini_read(config_path)
    end

    def ini_read(path)
      content = File.readlines(path, chomp:true).reject { |line| line.comment? }
      content.map { |line| line.split(/\s*=\s*/, 2) }.to_h
    end

    def match(req)
      redirects.each do |pattern, target|
        pattern = "#{pattern}/" unless pattern.include? "/" 
        requested = "#{req.host}#{req.path}"
        matcher = Mustermann.new(pattern)
        params = matcher.params(requested)
        if params
          params.transform_keys! &:to_sym
          params.delete :splat
          params.transform_values! { |v| CGI.escape v }
          return target % params
        end
      end

      nil
    end

  end
end
