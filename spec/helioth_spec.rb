require 'spec_helper'

describe Helioth do
  context "DSL" do
    it 'should throw an error' do
      expect { Helioth::DSL }.to raise_error
    end
  end

  context ".dsl" do
    it 'should throw an error with an invalid DSL file' do
      expect { Helioth.dsl("spec/fixtures/invalid_dsl.rb") }.to raise_error
    end

    it 'should load the DSL with a valid DSL' do
      expect { Helioth.dsl("spec/fixtures/valid_dsl.rb") }.to_not raise_error
    end
  end
end
