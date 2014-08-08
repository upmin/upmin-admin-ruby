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

  def upmin_attributes
    self.class.upmin_attributes
  end


  module ClassMethods

    def upmin_attributes(*attributes)
      if attributes.any?
        @upmin_attributes = attributes.map{|a| a.to_sym}
      end
      @upmin_attributes ||= attribute_names.map{|a| a.to_sym}
      return @upmin_attributes
    end

    def upmin_actions(*actions)
      if actions.any?
        @upmin_actions = actions.map{|a| a.to_sym}
      end
      @upmin_actions ||= []
      return @upmin_actions
    end

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
