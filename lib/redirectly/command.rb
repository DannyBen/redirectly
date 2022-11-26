require 'colsole'
require 'mister_bin'

module Redirectly
  class Command < MisterBin::Command
    include Colsole
    help 'Start the redirect server'
    version Redirectly::VERSION

    usage 'redirectly [CONFIG --port PORT]'
    usage 'redirectly --init'
    usage 'redirectly --help | --version'

    option '-p --port PORT', 'Listening port [default: 3000]'
    option '-i --init', 'Create a sample config file and exit'

    param 'CONFIG', 'Path to config file [default: redirects.ini]'

    example 'redirectly --init'
    example 'redirectly config.ini'

    attr_reader :config_path, :port

    def run
      @port = args['--port'].to_i
      @config_path = args['CONFIG'] || 'redirects.ini'
      args['--init'] ? init_file : start_server
    end

  private

    def init_file
      raise ArgumentError, "#{config_path} already exists" if File.exist? config_path

      File.write config_path, template
      say "Initialized #{config_path}"
    end

    def template
      <<~TEMPLATE
        example.com = https://other-site.com/
        *.mygoogle.com/:anything = https://google.com/?q=%{anything}
        example.org/* = https://other-site.com/
        *.old-site.com = !https://permanent.redirect.com
        :sub.lvh.me/* = http://it-works.com/%{sub}
      TEMPLATE
    end

    def start_server
      raise ArgumentError, "Cannot find config file #{config_path}" unless File.exist? config_path

      Rack::Server.start(app: app, Port: port, environment: 'production')
    end

    def app
      @app ||= Redirectly::App.new config_path
    end
  end
end
