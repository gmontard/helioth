require 'spec_helper'

describe Helioth::ControllerAdditions do

  before(:each) do
    stub_const("DSL", Helioth::Dsl.load("spec/fixtures/valid_dsl.rb"))
  end

  describe ".load_and_authorize_for" do
    it "should be an ApplicationController method" do
      expect(ApplicationController.public_methods.include?(:load_and_authorize_for)).to be(true)
    end
  end

  describe "#access_to?" do
    it "should return a boolean" do
      expect_any_instance_of(User).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_user).and_return(User.new)

      expect_any_instance_of(Instance).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_instance).and_return(Instance.new)

      boolean = ActionController::Base.new.access_to?(:no_name)
      expect( !!boolean ).to be(boolean)
    end

    it "should return false when locale_access is false" do
      expect_any_instance_of(ActionController::Base).to receive(:locale_access_to?).and_return(false)
      expect( ActionController::Base.new.access_to?(:no_name) ).to be(false)
    end

    describe "when locale_access is true" do
      before(:each) do
        expect_any_instance_of(ActionController::Base).to receive(:locale_access_to?).and_return(true)
      end

      it "should return true if user_access is true" do
        expect_any_instance_of(ActionController::Base).to receive(:user_access_to?).and_return(true)
        expect( ActionController::Base.new.access_to?(:no_name) ).to be(true)
      end

      describe "and user_access is false" do
        before(:each) do
          expect_any_instance_of(ActionController::Base).to receive(:user_access_to?).and_return(false)
        end

        it "should return true if instance_access is true" do
          expect_any_instance_of(ActionController::Base).to receive(:instance_access_to?).and_return(true)
          expect( ActionController::Base.new.access_to?(:no_name) ).to be(true)
        end

        it "should return false if instance_access is false" do
          expect_any_instance_of(ActionController::Base).to receive(:instance_access_to?).and_return(false)
          expect( ActionController::Base.new.access_to?(:no_name) ).to be(false)
        end
      end
    end
  end

  describe "#locale_access_to?" do
    it "should return a boolean" do
      boolean = ActionController::Base.new.locale_access_to?(:no_name)
      expect( !!boolean ).to be(boolean)
    end

    it "should thrown an error when no argument is used" do
      expect{ ActionController::Base.new.locale_access_to? }.to raise_error(ArgumentError)
    end

    it "should accept a list of arguments" do
      expect{ ActionController::Base.new.locale_access_to?(:no_name, :index, :search) }.to_not raise_error
    end
  end

  describe "#user_access_to?" do
    it "should return a boolean" do
      expect_any_instance_of(User).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_user).and_return(User.new)

      boolean = ActionController::Base.new.user_access_to?(:no_name)
      expect( !!boolean ).to be(boolean)
    end

    it "should thrown an error when no argument is used" do
      expect{ ActionController::Base.new.user_access_to? }.to raise_error(ArgumentError)
    end

    it "should accept a list of arguments" do
      expect_any_instance_of(User).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_user).and_return(User.new)
      expect{ ActionController::Base.new.user_access_to?(:no_name, :index, :search) }.to_not raise_error
    end
  end

  describe "#instance_access_to?" do
    it "should return a boolean" do
      expect_any_instance_of(Instance).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_instance).and_return(Instance.new)

      boolean = ActionController::Base.new.instance_access_to?(:no_name)
      expect( !!boolean ).to be(boolean)
    end

    it "should thrown an error when no argument is used" do
      expect{ ActionController::Base.new.instance_access_to? }.to raise_error(ArgumentError)
    end

    it "should accept a list of arguments" do
      expect_any_instance_of(Instance).to receive(:helioth_role?).and_return(:beta)
      expect_any_instance_of(ActionController::Base).to receive(:current_instance).and_return(Instance.new)

      expect{ ActionController::Base.new.instance_access_to?(:no_name, :index, :search) }.to_not raise_error
    end
  end

end
