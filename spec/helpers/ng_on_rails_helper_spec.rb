require 'rails_helper'

RSpec.describe NgOnRailsHelper, :type => :helper do
  describe '#locals_to_json' do
    xit 'is empty without instance variables' do
      expect( JSON.parse(locals_to_json(nil)) ).to be_blank
    end

    xit 'is not empty with instance variables' do
      @test_var_1 = 1
      @test_var_2 = 2
      expect( JSON.parse(locals_to_json(nil)) ).to_not be_blank
      expect( JSON.parse(locals_to_json(nil))[:test_var_1] ).to be(1)
      expect( JSON.parse(locals_to_json(nil))[:test_var_2] ).to be(2)
    end
  end
end