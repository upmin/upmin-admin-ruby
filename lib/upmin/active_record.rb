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
    return self.class.upmin_attributes
  end

  def upmin_name(type = :plural)
    return self.class.upmin_name(type)
  end

  def upmin_color
    return self.class.upmin_color
  end

  def upmin_editable?(attr_name)
    return false if attr_name == :id || attr_name == "id"
    # TODO(jon): Add a way to lock this later
    return self.respond_to?("#{attr_name}=")
  end

  def upmin_get(attr_name)
    if uc = self.class.columns_hash[attr_name.to_s]
      return Upmin::Datatypes::Boolean.new(send(attr_name)) if uc.type == :boolean
    end

    return send(attr_name)
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

    def upmin_name(type = :plural)
      names = name.gsub(/([a-z])([A-Z])/, "#{$1} #{$2}").split(" ")
      if type == :plural
        names[names.length-1] = names.last.pluralize
      end
      return names.join(" ")
    end

    def upmin_color
      return @upmin_color if defined?(@upmin_color)
      return @upmin_color = Upmin::Server::Model.color_for(self.name)
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
