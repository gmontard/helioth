require 'spec_helper'

describe Helioth::Dsl do

  before(:all) do
    @dsl = Helioth::Dsl.load("spec/fixtures/valid_dsl.rb")
  end

  describe "#features" do
    it "should retrieve all features" do
      expect(@dsl.features.size).to be == 3
    end
  end

  describe "#feature" do
    it "should retrieve the feature :tutoring" do
      expect(@dsl.feature(:tutoring)).to be_an_instance_of(Helioth::Feature)
      expect(@dsl.feature(:tutoring).name).to be == :tutoring
    end
  end

  describe "#action" do
    it "should find the action :search for :tutoring" do
      expect(@dsl.action(:tutoring, :search)).to be_an_instance_of(Helioth::Action)
      expect(@dsl.action(:tutoring, :search).name).to be == :search
    end

    it "should not find the action :search for :no_name" do
      expect(@dsl.action(:no_name, :search)).to be == nil
    end
  end
end
