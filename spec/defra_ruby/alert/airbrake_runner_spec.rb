# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Alert
    RSpec.describe AirbrakeRunner do
      before do
        DefraRuby::Alert.configure do |c|
          c.enabled = enabled
          c.host = host
          c.project_key = project_key
        end

        allow(configuration).to receive_messages(
          :host= => nil,
          :project_key= => nil,
          :project_id= => nil,
          :root_directory= => nil,
          :logger= => nil,
          :environment= => nil,
          :ignore_environments= => nil,
          :blocklist_keys= => nil,
          :performance_stats= => nil,
          :remote_config= => nil
        )
        allow(configuration).to receive(:performance_stats)

        allow(Airbrake).to receive(:configure).and_yield(configuration)
      end

      let(:configuration) { instance_double("Configuration") } # rubocop:disable RSpec/VerifiedDoubleReference

      let(:enabled) { true }
      let(:host) { "http://localhost:8005" }
      let(:project_key) { "ABC123456789" }

      describe ".invoke" do
        before { allow(Airbrake).to receive(:add_filter) }

        it "configures Airbrake with host" do
          described_class.invoke

          expect(configuration).to have_received(:host=).with(host)
        end

        it "configures Airbrake with project_key" do
          described_class.invoke

          expect(configuration).to have_received(:project_key=).with(project_key)
        end

        context "when airbrake is enabled" do
          it "does not tell Airbrake to ignore everything" do
            described_class.invoke

            expect(Airbrake).not_to have_received(:add_filter)
          end
        end

        context "when airbrake is not enabled" do
          let(:enabled) { false }

          # rubocop:disable RSpec/MultipleExpectations
          it "tells Airbrake to ignore everything" do
            described_class.invoke

            expect(Airbrake).to have_received(:add_filter) { |&block| expect(block).to be(&:ignore!) }
          end
          # rubocop:enable RSpec/MultipleExpectations

        end
      end

    end
  end
end
