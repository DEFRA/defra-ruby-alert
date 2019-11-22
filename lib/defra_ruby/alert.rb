# frozen_string_literal: true

require_relative "alert/airbrake_runner"
require_relative "alert/configuration"

module DefraRuby
  module Alert
    class << self

      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
        @configuration
      end

      def start
        AirbrakeRunner.invoke
      end
    end
  end
end
