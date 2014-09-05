require 'spec_helper'

describe Helioth::Relation do

  before(:all) do
    @relation = Helioth::Relation.new do
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

  describe "@feature" do
    it "should be a Hash" do
      expect(@relation.instance_variable_get(:@feature)).to be_an_instance_of(Hash)
    end

    it "should contain all feature status as hash keys" do
      expect(@relation.instance_variable_get(:@feature).keys).to contain_exactly(:beta, :pre_release, :production)
    end

    it "should contain for each keys a hash" do
      @relation.instance_variable_get(:@feature).each{|k,v|
        expect(v).to be_an_instance_of(Hash)
      }
    end

    it "should contain for each keys a hash with :instance and :user keys" do
      @relation.instance_variable_get(:@feature).each{|k,v|
        expect(v.keys).to contain_exactly(:user, :instance)
      }
    end

    it "should match all relations described in the DSL" do
      expect(@relation.instance_variable_get(:@feature)[:beta][:instance]).to contain_exactly(:beta)
      expect(@relation.instance_variable_get(:@feature)[:pre_release][:instance]).to contain_exactly(:beta, :standard)
      expect(@relation.instance_variable_get(:@feature)[:production][:instance]).to contain_exactly(:beta, :standard, :critical)
      expect(@relation.instance_variable_get(:@feature)[:beta][:user]).to contain_exactly(:beta)
      expect(@relation.instance_variable_get(:@feature)[:pre_release][:user]).to contain_exactly(:beta)
      expect(@relation.instance_variable_get(:@feature)[:production][:user]).to contain_exactly(:beta, :standard)
    end
  end
end
