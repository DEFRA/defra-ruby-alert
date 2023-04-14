# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Alert
    RSpec.describe Configuration do

      subject(:fresh_config) { described_class.new }

      it { expect(fresh_config.root_directory).to be_nil }
      it { expect(fresh_config.logger).to be_nil }
      it { expect(fresh_config.environment).to be_nil }
      it { expect(fresh_config.host).to be_nil }
      it { expect(fresh_config.project_key).to be_nil }
      it { expect(fresh_config.blocklist).to eq([]) }
      it { expect(fresh_config.enabled).to be(false) }
    end
  end
end
