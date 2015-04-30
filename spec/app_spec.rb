require 'spec_helper'
require 'resources'

describe "GEM" do

  let(:main_module) { Resources }

  let(:country){ create(:country) }

  context "When Module is loaded" do
    it do
      expect{main_module}.not_to raise_error
    end
  end

end
