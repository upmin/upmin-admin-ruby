require 'set'

module AccordiveRails
  class SearchEngine

    def self.search(models, attributes, query)
      ret = Set.new

      models.each do |model|
        attributes.each do |attribute|
          if model.support_attributes.include?(attribute)
            if [:string, :integer].include?(model.attribute_type(attribute))
              ret += model.where(attribute => query).accordify
            end
          end
        end
      end

      return ret.to_a
    end

  end
end
