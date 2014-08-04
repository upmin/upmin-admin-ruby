require 'active_support/concern'

module JettyAdmin
end

module JettyAdmin::ActiveRecord
  extend ActiveSupport::Concern

  included do
    after_save :notify_jetty_of_save
  end

  def notify_jetty_of_save
    # if JettyAdmin::Model.search_indexes[self.class.to_s]
    #   # TODO(jon): Post a message to Jetty with: [class, id]
    #   puts "Called notify_jetty_of_save"
    # end
  end

  module ClassMethods

    def ac_updated_after(date, page = 1)
      page = [1, page].max - 1
      where("updated_at > ?", date).limit(10).offset(page * 10).order("updated_at ASC")
    end


    # Expects something like:
    #
    #   admin_search name: :partial,
    #                email: :exact,
    #                external_id: :exact,
    #                description: :none
    #
    def admin_search(*array)
      @ac_admin_search_index = array
    end

    def admin_search_index
      return @ac_admin_search_index || attribute_names
    end

  end
end
