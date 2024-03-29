# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::Alert do
  describe "VERSION" do
    it { expect(DefraRuby::Alert::VERSION).to be_a(String) }
    it { expect(DefraRuby::Alert::VERSION).to match(/\d+\.\d+\.\d+/) }
  end

  describe ".configuration" do
    context "when the host app has not provided configuration" do
      it "returns a DefraRuby::Alert::Configuration instance" do
        expect(described_class.configuration).to be_an_instance_of(DefraRuby::Alert::Configuration)
      end
    end

    context "when the host app has provided configuration" do
      let(:host) { "http://localhost:9012" }

      it "returns an DefraRuby::Alert::Configuration instance with a matching host" do
        described_class.configure { |config| config.host = host }

        expect(described_class.configuration.host).to eq(host)
      end
    end
  end

  describe ".start" do
    before do
      allow(DefraRuby::Alert::AirbrakeRunner).to receive(:invoke)

      described_class.configure do |c|
        c.enabled = false
        c.host = "http://localhost:8005"
        c.project_key = "ABC123456789"
      end
    end

    it "invokes 'AirbrakeRunner'" do
      described_class.start

      expect(DefraRuby::Alert::AirbrakeRunner).to have_received(:invoke)
    end
  end
end
