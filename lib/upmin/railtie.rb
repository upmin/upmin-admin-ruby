require 'rails/railtie'

module Upmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('upmin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        if defined?(ActiveRecord)
          ::ActiveRecord::Base.send(:include, Upmin::Railties::ActiveRecord)
          ::ActiveRecord::Base.send(:extend, Upmin::Railties::Dashboard)
        end

        if defined?(DataMapper)
          ::DataMapper::Resource.send(:include, Upmin::Railties::DataMapper)
        end
        # ::ActiveRecord::Relation.send(:include, Upmin::ActiveRecordRelation)
      end
    end

    initializer('upmin.insert_view_helpers') do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, Upmin::Railties::Render)
        ::ActionController::Base.send(:include, Upmin::Railties::Paginator)
      end

      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send(:include, Upmin::Railties::Render)
        ::ActionView::Base.send(:include, Upmin::Railties::Paginator)
      end
    end
  end
end
