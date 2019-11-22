# frozen_string_literal: true

require "airbrake"

module DefraRuby
  module Alert
    class AirbrakeRunner

      def self.invoke
        configure

        if DefraRuby::Alert.configuration.enabled
          # Register an `at_exit` hook that runs when the host app shuts down
          at_exit { perform_at_exit }

          return
        end

        # Unfortunately the airbrake initializer errors if project_key is not set. The
        # problem is that the initializer is fired in scenarios where we are not
        # actually using the app, for example when running a rake task.
        #
        # In production when we run rake tasks it's in an environment where environment
        # variables have not been set. As such we need a way to disable using Airbrake
        # unless we actually need it.
        Airbrake.add_filter(&:ignore!)
      end

      private_class_method def self.perform_at_exit
        Airbrake.close
      rescue StandardError => e
        puts "Airbrake reported an error when closing. \
              Its probaly fine and just because there were no errors to report: #{e.message}"
      end

      private_class_method def self.configure
        Airbrake.configure do |c|
          # You must set both project_id & project_key. To find your project_id and
          # project_key navigate to your project's General Settings and copy the values
          # from the right sidebar.
          # https://github.com/airbrake/airbrake-ruby#project_id--project_key
          c.host = DefraRuby::Alert.configuration.host
          c.project_key = DefraRuby::Alert.configuration.project_key
          c.project_id = 1

          # Configures the root directory of your project. Expects a String or a
          # Pathname, which represents the path to your project. Providing this option
          # helps us to filter out repetitive data from backtrace frames and link to
          # GitHub files from our dashboard.
          # https://github.com/airbrake/airbrake-ruby#root_directory
          c.root_directory = DefraRuby::Alert.configuration.root_directory

          # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
          # use the Rails' logger.
          # https://github.com/airbrake/airbrake-ruby#logger
          c.logger = DefraRuby::Alert.configuration.logger

          # Configures the environment the application is running in. Helps the Airbrake
          # dashboard to distinguish between exceptions occurring in different
          # environments. By default, it's not set.
          # NOTE: This option must be set in order to make the 'ignore_environments'
          # option work.
          # https://github.com/airbrake/airbrake-ruby#environment
          c.environment = DefraRuby::Alert.configuration.environment

          # Setting this option allows Airbrake to filter exceptions occurring in
          # unwanted environments such as :test. By default, it is equal to an empty
          # Array, which means Airbrake Ruby sends exceptions occurring in all
          # environments.
          # NOTE: This option *does not* work if you don't set the 'environment' option.
          # https://github.com/airbrake/airbrake-ruby#ignore_environments
          c.ignore_environments = %w[test]

          # A list of parameters that should be filtered out of what is sent to
          # Airbrake. By default, all "password" attributes will have their contents
          # replaced.
          # https://github.com/airbrake/airbrake-ruby#blacklist_keys
          c.blacklist_keys = DefraRuby::Alert.configuration.blacklist
        end
      end
    end
  end
end
