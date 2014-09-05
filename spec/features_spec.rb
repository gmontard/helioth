require 'spec_helper'

describe Helioth::Features do

  before(:all) do
    @features = Helioth::Features.new do
      feature :no_name do
        status :disabled
      end

      feature :no_name2 do
        status :beta
      end
    end
  end

  describe "#feature" do
    it "should raise an ArgumentError error if no parameters passed" do
      expect{@features.feature}.to raise_error(ArgumentError)
    end
  end

  describe "#list" do
    it "should be an Array" do
      expect(@features.list).to be_an_instance_of(Array)
    end

    it "should contain 2 elements" do
      expect(@features.list.size).to be == 2
    end

    it "should contain instances of Helioth::Feature" do
      expect(@features.list.first).to be_an_instance_of(Helioth::Feature)
    end
  end

end
