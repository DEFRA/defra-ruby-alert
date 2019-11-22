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
          :blacklist_keys= => nil
        )

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
          it "registers an 'at_exit' hook" do
            expect(described_class).to receive(:at_exit)

            described_class.invoke
          end

          it "does not tell Airbrake to ignore everything" do
            expect(Airbrake).not_to receive(:add_filter)

            described_class.invoke
          end
        end

        context "when airbrake is not enabled" do
          let(:enabled) { false }

          it "does not register an 'at_exit' hook" do
            expect(described_class).to receive(:at_exit).never

            described_class.invoke
          end

          it "tells Airbrake to ignore everything" do
            expect(Airbrake).to receive(:add_filter) { |&block| expect(block).to be(&:ignore!) }

            described_class.invoke
          end
        end
      end

    end
  end
end