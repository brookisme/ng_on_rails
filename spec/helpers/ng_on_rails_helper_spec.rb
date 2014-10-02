require 'rails_helper'

RSpec.describe NgOnRailsHelper, :type => :helper do
  describe '#locals_to_json' do
    context 'without instance variables' do 
      it 'is empty' do
        expect( JSON.parse(locals_to_json(nil)) ).to be_blank
      end
    end

    context 'with instance variables' do
      it 'is not empty' do
        @test_var_1 = 1
        expect( JSON.parse(locals_to_json(nil)) ).to_not be_blank
      end

      it 'contains the correct key/value pairs' do
        @test_var_2 = [2,5,"three"]
        @test_var_3 = "some string"
        @test_var_4 = {"a" => "Hello", "b" => "World"}
        expect( JSON.parse(locals_to_json(nil))["test_var_2"] ).to eq(@test_var_2)
        expect( JSON.parse(locals_to_json(nil))["test_var_3"] ).to eq(@test_var_3)
        expect( JSON.parse(locals_to_json(nil))["test_var_4"] ).to eq(@test_var_4)
      end
      
      it 'returns and object from a json string' do
        @test_var_4 = {"a" => "Hello", "b" => "World"}
        @test_var_5 = @test_var_4.to_json
        expect( JSON.parse(locals_to_json(nil))["test_var_5"] ).to_not eq(@test_var_5)
        expect( JSON.parse(locals_to_json(nil))["test_var_5"] ).to eq(@test_var_4)
      end
    end
  end
end