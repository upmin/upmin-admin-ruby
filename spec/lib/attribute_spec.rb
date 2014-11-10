require 'spec_helper'

describe Upmin::Attribute do

  if ActiveRecord::Base.respond_to? :enum
    describe '#enum_options' do
      it 'returns options for an enum attribute' do
        model = Upmin::Model.find_class(UserWithRoleEnum).new
        attribute = Upmin::Attribute.new(model, :role)
        expect(attribute.enum_options).to eq ['default', 'admin']
      end
    end
  end

end
