require 'mister_bin'
require 'redirectly/command'

module Redirectly
  class CLI
    def self.router
      router = MisterBin::Runner.new version: VERSION,
        header: "Redirectly Redirect Server"

      router.route_all to: Command
      router
    end
  end
end
