require 'spec_helper'

describe Helioth::Feature do

  before(:all) do
    @feature = Helioth::Feature.new :no_name do
      status :disabled
      locales :en, :fr, :br
      actions :index do
        status :beta
      end
    end
  end

  describe "#status" do
    it "should find correct :status" do
      expect(@feature.status).to be == :disabled
    end
  end

  describe "#locales" do
    it "should find correct :locales" do
      expect(@feature.locales).to be == [:en, :fr, :br]
    end

    it 'should find correct :locales when not defined' do
      @feature = Helioth::Feature.new :test do
        status :disabled
      end

      expect(@feature.locales).to be == I18n.available_locales
    end
  end

  describe "#actions" do
    it "should find correct :actions" do
      expect(@feature.actions.size).to be == 1
      expect(@feature.actions.first).to be_an_instance_of(Helioth::Action)
      expect(@feature.actions.first.name).to be == :index
    end
  end

  describe "#action" do
    it "should find specific related action" do
      expect(@feature.action(:index)).to be_an_instance_of(Helioth::Action)
      expect(@feature.action(:index).name).to be == :index
    end
  end
end
