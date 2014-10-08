require 'spec_helper'

describe Helioth::ModelAdditions do

  before(:all) do
    Helioth::Dsl.load("spec/fixtures/valid_dsl.rb")
  end

  describe "with standard column :role" do
    before(:all) do
      class User < ActiveRecord::Base
        belongs_to :instance
        accepts_nested_attributes_for :instance
        has_helioth_role :user, column: :role
      end

      class Instance < ActiveRecord::Base
        has_helioth_role :instance, column: :role
      end
    end

    describe "#validations" do
      it "should validate role based on DSL defintion" do
        Helioth::DSL.roles.user.each{|role|
          expect(User.new(role: role.to_s)).to be_valid
        }

        Helioth::DSL.roles.instance.each{|role|
          expect(Instance.new(role: role.to_s)).to be_valid
        }
      end

      it "shouldn't validate role based on DSL definition" do
        expect(User.new(role: "none")).to be_invalid
        expect(Instance.new(role: "none")).to be_invalid
      end
    end

    describe "#role?" do
      it "should return user role as a Symbol" do
        expect(User.new(role: "beta").role).to be(:beta)

        expect(Instance.new(role: "production").role).to be(:production)
      end
    end

    describe "#helioth_role?" do
      it "should return user role as a Symbol" do
        expect(User.new(role: "beta").helioth_role?).to be(:beta)

        expect(Instance.new(role: "production").helioth_role?).to be(:production)
      end
    end

    describe "#is_role?" do
      it "should return true if user role match argument" do
        expect(User.new(role: "beta").is_role?(:beta)).to be(true)
        expect(User.new(role: "beta").is_role?("beta")).to be(true)

        expect(Instance.new(role: "production").is_role?(:production)).to be(true)
        expect(Instance.new(role: "production").is_role?("production")).to be(true)
      end

      it "should return false if user role match argument" do
        expect(User.new(role: "beta").is_role?(:none)).to be(false)
        expect(User.new(role: "beta").is_role?("none")).to be(false)

        expect(Instance.new(role: "production").is_role?(:none)).to be(false)
        expect(Instance.new(role: "production").is_role?("none")).to be(false)
      end
    end
  end

  describe "with non standard column :status as role" do
    before(:all) do
      class User2 < ActiveRecord::Base
        belongs_to :instance2
        accepts_nested_attributes_for :instance2
        has_helioth_role :user, column: :status
      end

      class Instance2 < ActiveRecord::Base
        has_helioth_role :instance, column: :status
      end
    end

    describe "#validations" do
      it "should validate role based on DSL defintion" do
        Helioth::DSL.roles.user.each{|role|
          expect(User2.new(status: role.to_s)).to be_valid
        }

        Helioth::DSL.roles.instance.each{|role|
          expect(Instance2.new(status: role.to_s)).to be_valid
        }
      end

      it "shouldn't validate role based on DSL definition" do
        expect(User2.new(status: "none")).to be_invalid
        expect(Instance2.new(status: "none")).to be_invalid
      end
    end

    describe "#role?" do
      it "should return user role as a Symbol" do
        expect(User2.new(status: "beta").status).to be(:beta)

        expect(Instance2.new(status: "production").status).to be(:production)
      end
    end

    describe "#helioth_role?" do
      it "should return user role as a Symbol" do
        expect(User2.new(status: "beta").helioth_role?).to be(:beta)

        expect(Instance2.new(status: "production").helioth_role?).to be(:production)
      end
    end

    describe "#is_role?" do
      it "should return true if user role match argument" do
        expect(User2.new(status: "beta").is_status?(:beta)).to be(true)
        expect(User2.new(status: "beta").is_status?("beta")).to be(true)

        expect(Instance2.new(status: "production").is_status?(:production)).to be(true)
        expect(Instance2.new(status: "production").is_status?("production")).to be(true)
      end

      it "should return false if user role match argument" do
        expect(User2.new(status: "beta").is_status?(:none)).to be(false)
        expect(User2.new(status: "beta").is_status?("none")).to be(false)

        expect(Instance2.new(status: "production").is_status?(:none)).to be(false)
        expect(Instance2.new(status: "production").is_status?("none")).to be(false)
      end
    end
  end
end
