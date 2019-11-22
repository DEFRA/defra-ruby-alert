# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Alert
    RSpec.describe Configuration do
      it "sets the appropriate default config settings" do
        fresh_config = described_class.new

        expect(fresh_config.root_directory).to be_nil
        expect(fresh_config.logger).to be_nil
        expect(fresh_config.environment).to be_nil

        expect(fresh_config.host).to be_nil
        expect(fresh_config.project_key).to be_nil
        expect(fresh_config.blacklist).to eq([])
        expect(fresh_config.enabled).to eq(false)
      end
    end
  end
end
