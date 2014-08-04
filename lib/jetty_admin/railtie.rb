module JettyAdmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('jetty_admin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, JettyAdmin::ActiveRecord)
        # ::ActiveRecord::Relation.send(:include, JettyAdmin::ActiveRecordRelation)
      end
    end
  end
end
