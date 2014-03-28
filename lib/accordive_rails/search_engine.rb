require 'set'

module AccordiveRails
  class SearchEngine

    def self.search(models, attributes, query)
      ret = Set.new

      models.each do |model|
        model.search_with.each do |search_method|
          ret += model.send(search_method, query)
        end
      end

      return ret.to_a
    end

  end
end
