module Upmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('upmin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, Upmin::Railties::ActiveRecord)
        # ::ActiveRecord::Relation.send(:include, Upmin::ActiveRecordRelation)
      end

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
