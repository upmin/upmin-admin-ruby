module Upmin
  module Server
    class Model < Client

      def Model.root_url
        return "#{Client.root_url}/models"
      end

      def Model.color_for(model_name)
        m = all.select{|m| m.name == model_name}.first
        return m.color
      end

      def name
        return self[:name]
      end

      def color
        return self[:color]
      end

      def search_data
        return {
          name: name,
          color: color
        }
      end
    end
  end
end
