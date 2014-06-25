module AccordiveAdmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('accordive_admin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, AccordiveAdmin::ActiveRecord)
        # ::ActiveRecord::Relation.send(:include, AccordiveAdmin::ActiveRecordRelation)
      end
    end
  end
end
