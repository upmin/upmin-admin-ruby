module Upmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('upmin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, Upmin::ActiveRecord)
        # ::ActiveRecord::Relation.send(:include, Upmin::ActiveRecordRelation)
      end
    end
  end
end
