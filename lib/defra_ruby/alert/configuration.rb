# frozen_string_literal: true

module DefraRuby
  module Alert
    class Configuration
      attr_accessor :root_directory, :logger, :environment, :host, :project_key, :blocklist, :enabled

      def initialize
        @blocklist = []
        @enabled = false
      end
    end
  end
end
