module Upmin
  require 'rails'
  class Railtie < Rails::Railtie
    initializer('upmin.insert_into_active_record') do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, Upmin::ActiveRecord)
        # ::ActiveRecord::Relation.send(:include, Upmin::ActiveRecordRelation)
      end

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, Upmin::RenderHelpers)
      end

      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send(:include, Upmin::RenderHelpers)
      end
    end
  end
end
