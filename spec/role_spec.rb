require 'spec_helper'

describe Helioth::Role do

  before(:all) do
    @role = Helioth::Role.new do
      user :beta, :standard
      instance :beta, :standard, :critical
      feature :disabled, :beta, :pre_release, :production
    end
  end

  describe "#user" do
    it "should find all user roles" do
      expect(@role.user).to be == [:beta, :standard]
    end
  end

  describe "#instance" do
    it "should find all instance roles" do
      expect(@role.instance).to be == [:beta, :standard, :critical]
    end
  end

  describe "#feature" do
    it "should find all feature roles" do
      expect(@role.feature).to be == [:disabled, :beta, :pre_release, :production]
    end
  end

end
