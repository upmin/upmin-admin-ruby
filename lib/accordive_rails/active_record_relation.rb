require 'active_support/concern'
require 'accordive_rails/instance'

module AccordiveRails
end

module AccordiveRails::ActiveRecordRelation
  extend ActiveSupport::Concern

  def accordify
    map { |i| AccordiveRails::Instance.new(i) }
  end

end
