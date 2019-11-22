# frozen_string_literal: true

module DefraRuby
  module Alert
    class Configuration
      attr_accessor :root_directory, :logger, :environment
      attr_accessor :host, :project_key, :blacklist, :enabled

      def initialize
        @blacklist = []
        @enabled = false
      end
    end
  end
end
