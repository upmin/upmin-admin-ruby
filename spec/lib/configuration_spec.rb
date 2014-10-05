# encoding: UTF-8
require "spec_helper"

describe Upmin::Configuration do
  before(:each) do
    @config = Upmin::Configuration.new
  end

  describe "#colors" do

    context "default colors" do
      it { expect(@config.colors).to(include(:red)) }
      it { expect(@config.colors).to(include(:green)) }

      describe "#length" do
        it { expect(@config.colors.length).to(be >= 9) }
      end
    end

    context "custom colors" do
      before(:each) { @config.colors = [:red, :blue] }

      it { expect(@config.colors).to(include(:red)) }
      it { expect(@config.colors).to(include(:blue)) }
      it { expect(@config.colors).not_to(include(:green)) }

      describe "#length" do
        it { expect(@config.colors.length).to(eq(2)) }
      end
    end

  end

  describe "#models" do

    context "default models" do
      it { expect(@config.models).to(include(:user)) }
      it { expect(@config.models).to(include(:order)) }
      it { expect(@config.models).to(include(:product)) }

      describe "#length" do
        it { expect(@config.models.length).to(be >= 4) }
      end
    end

    context "custom models" do
      before(:each) { @config.models = [:user, :order] }

      it { expect(@config.models).to(include(:user)) }
      it { expect(@config.models).to(include(:order)) }
      it { expect(@config.models).not_to(include(:product)) }

      describe "#length" do
        it { expect(@config.models.length).to(eq(2)) }
      end
    end

  end

  describe "#items_per_page" do

    context "default items_per_page" do
      it { expect(@config.items_per_page).to(eq(30)) }
    end

    context "custom items_per_page" do
      before(:each) { @config.items_per_page = 10 }
      it { expect(@config.items_per_page).to(eq(10)) }
    end

  end

end
