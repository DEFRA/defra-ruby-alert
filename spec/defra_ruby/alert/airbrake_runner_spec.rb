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
          :performance_stats= => nil
        )
        allow(configuration).to receive(:performance_stats)

        allow(Airbrake).to receive(:configure).and_yield(configuration)
      end

      let(:configuration) { double("Configuration") }

      let(:enabled) { true }
      let(:host) { "http://localhost:8005" }
      let(:project_key) { "ABC123456789" }

      describe ".invoke" do
        it "configures Airbrake" do
          expect(configuration).to receive(:host=).with(host)
          expect(configuration).to receive(:project_key=).with(project_key)

          described_class.invoke
        end

        context "when airbrake is enabled" do
          it "does not tell Airbrake to ignore everything" do
            expect(Airbrake).not_to receive(:add_filter)

            described_class.invoke
          end
        end

        context "when airbrake is not enabled" do
          let(:enabled) { false }

          it "tells Airbrake to ignore everything" do
            expect(Airbrake).to receive(:add_filter) { |&block| expect(block).to be(&:ignore!) }

            described_class.invoke
          end
        end
      end

    end
  end
end
