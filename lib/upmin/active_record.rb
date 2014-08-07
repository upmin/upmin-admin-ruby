require 'active_support/concern'

module Upmin
end

module Upmin::ActiveRecord
  extend ActiveSupport::Concern

  included do
    after_save :notify_upmin_of_save
  end

  def notify_upmin_of_save
    # if Upmin::Model.search_indexes[self.class.to_s]
    #   # TODO(jon): Post a message to Upmin with: [class, id]
    #   puts "Called notify_upmin_of_save"
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
