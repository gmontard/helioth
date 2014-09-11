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

  describe "#authorized_for_locale?" do
    describe "when available locales locales is :en" do
      it "should be true for feature :tutoring and locale :en" do
        expect(@dsl.authorized_for_locale?(:tutoring, [], :en)).to be(true)
      end

      it "should be false for feature :tutoring and locale :fr" do
        expect(@dsl.authorized_for_locale?(:tutoring, [], :fr)).to be(false)
      end

      it "should be true for feature :tutoring, action :search and locale :fr" do
        expect(@dsl.authorized_for_locale?(:tutoring, [:search, :send], :fr)).to be(true)
      end

      it "should be false for feature :tutoring, action :search and locale :en" do
        expect(@dsl.authorized_for_locale?(:tutoring, [:search, :send], :en)).to be(false)
      end

      it "should be true for feature :social_learning and locale :fr" do
        expect(@dsl.authorized_for_locale?(:social_learning, [], :fr)).to be(true)
      end

      it "should be true for feature :social_learning and locale :en" do
        expect(@dsl.authorized_for_locale?(:social_learning, [], :en)).to be(true)
      end
    end

    describe "when available locales locales are [:fr, :en]" do
      before(:all) do
        I18n.available_locales = [:en, :fr]
        @dsl2 = Helioth::Dsl.load("spec/fixtures/valid_dsl.rb")
      end

      it "should be true for feature :tutoring and locale :fr" do
        expect(@dsl2.authorized_for_locale?(:tutoring, [], :fr)).to be(true)
      end

      it "should be true for feature :tutoring, action :search and locale :fr" do
        expect(@dsl2.authorized_for_locale?(:tutoring, [:search, :send], :fr)).to be(true)
      end

      it "should be false for feature :tutoring, action :search and locale :en" do
        expect(@dsl2.authorized_for_locale?(:tutoring, [:search, :send], :en)).to be(false)
      end
    end
  end

  describe "#authorized_for_user?" do
    it "should be false for all user and feature :no_name" do
      @dsl.roles.user.each{|role|
        expect(@dsl.authorized_for_user?(:no_name, [], role)).to be(false)
      }
    end

    it "should be true for user :beta and feature :tutoring" do
      expect(@dsl.authorized_for_user?(:tutoring, [], :beta)).to be(true)
    end

    it "should be false for user not :beta and feature :tutoring" do
      @dsl.roles.user.reject!{|e| e==:beta }.each{|role|
        expect(@dsl.authorized_for_user?(:tutoring, [], role)).to be(false)
      }
    end

    it "should be false for user :standard, feature :tutoring and action :search" do
      expect(@dsl.authorized_for_user?(:tutoring, :search, :standard)).to be(false)
    end

    it "should be true for user :standard, feature :tutoring and action :index" do
      expect(@dsl.authorized_for_user?(:tutoring, :index, :standard)).to be(true)
    end
  end

  describe "#authorized_for_instance?" do
    it "should be false for all instance and feature :no_name" do
      @dsl.roles.instance.each{|role|
        expect(@dsl.authorized_for_instance?(:no_name, [], role)).to be(false)
      }
    end

    it "should be true for instance :beta and feature :tutoring" do
      expect(@dsl.authorized_for_instance?(:tutoring, [], :beta)).to be(true)
    end

    it "should be true for instance :standard and feature :tutoring" do
      expect(@dsl.authorized_for_instance?(:tutoring, [], :standard)).to be(true)
    end

    it "should be false for instance :critical and feature :tutoring" do
      expect(@dsl.authorized_for_instance?(:tutoring, [], :critical)).to be(false)
    end

    it "should be true for instance :critical, feature :tutoring and action :index" do
      expect(@dsl.authorized_for_instance?(:tutoring, :index, :critical)).to be(true)
    end

    it "should be true for instance :beta and feature :social_learning" do
      expect(@dsl.authorized_for_instance?(:social_learning, [], :beta)).to be(true)
    end

    it "should be false for instance :standard and feature :social_learning" do
      expect(@dsl.authorized_for_instance?(:social_learning, [], :standard)).to be(false)
    end

    it "should be false for instance :critical and feature :social_learning" do
      expect(@dsl.authorized_for_instance?(:social_learning, [], :critical)).to be(false)
    end
  end

end
