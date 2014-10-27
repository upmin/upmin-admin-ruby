require 'spec_helper'

describe Upmin::ActiveRecord::Model do

  describe ".attribute_type" do
    it "correctly identifies an enum attribute" do
      ActiveRecord::Migration.create_table(:user_with_role_enums) {|t| t.integer :role, default: 0 }
      class UserWithRoleEnum < ActiveRecord::Base; enum role: [:default, :admin] end
      model = Upmin::Model.find_class(UserWithRoleEnum).new
      attribute = Upmin::Attribute.new(model, :role)
      expect(attribute.type).to eq(:enum)
      ActiveRecord::Migration.drop_table :user_with_role_enums
    end
  end

end
