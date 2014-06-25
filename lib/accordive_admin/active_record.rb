require 'active_support/concern'

module AccordiveAdmin
end

module AccordiveAdmin::ActiveRecord
  extend ActiveSupport::Concern

  included do
    after_save :notify_accordive_of_save
  end

  def notify_accordive_of_save
    if AccordiveAdmin::Model.search_indexes[self.class.to_s]
      # TODO(jon): Post a message to Accordive with: [class, id]
      puts "Called notify_accordive_of_save"
    end
  end

  module ClassMethods

    # Expects something like:
    #
    #   admin_search name: :partial,
    #                email: :exact,
    #                external_id: :exact,
    #                description: :none
    #
    def admin_search(hash)
      @ac_admin_search_index = hash
    end

    def admin_search_index
      return @ac_admin_search_index
    end

  end
end
