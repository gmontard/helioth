require 'spec_helper'

describe Helioth::Relation do

  before(:all) do
    @role = Helioth::Relation.new do
      feature :disabled

      feature :beta do
        instance :beta
        user :beta
      end

      feature :pre_release do
        instance :beta, :standard
        user :beta
      end

      feature :production do
        instance :beta, :standard, :critical
        user :beta, :standard
      end
    end
  end

  describe "#feature" do
    pending
    it "" do

    end
  end

  describe "#instance" do
    pending
    it "" do

    end
  end

  describe "#user" do
    pending
    it "" do

    end
  end

end
