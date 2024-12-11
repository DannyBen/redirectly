require 'colsole'
require 'mister_bin'
require 'rackup'

module Redirectly
  class Command < MisterBin::Command
    include Colsole
    help 'Start the redirect server'
    version Redirectly::VERSION

    usage 'redirectly [CONFIG --port PORT --reload]'
    usage 'redirectly --init'
    usage 'redirectly -h | --help | --version'

    option '-p --port PORT', 'Listening port [default: 3000]'
    option '-i --init', 'Create a sample config file and exit'
    option '-r --reload', 'Read the INI file with every request'

    param 'CONFIG', 'Path to config file [default: redirects.ini]'

    environment 'REDIRECTLY_RELOAD', 'Set to a non empty value in order to read the INI file with every request (same as --reload)'

    example 'redirectly --init'
    example 'redirectly config.ini --port 4000 --reload'

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
        :sub.app.localhost/* = http://it-works.com/%{sub}
        proxy.localhost/*rest = @https://proxy.target.com/base/*rest
        internal.localhost/reload = :reload
        (*)old-domain.com/*rest = http://new-domain.com/%{rest}
      TEMPLATE
    end

    def start_server
      raise ArgumentError, "Cannot find config file #{config_path}" unless File.exist? config_path

      ENV['REDIRECTLY_RELOAD'] = '1' if args['--reload']
      Rackup::Server.start(app: app, Port: port, environment: 'production')
    end

    def app
      @app ||= Redirectly::App.new config_path
    end
  end
end
