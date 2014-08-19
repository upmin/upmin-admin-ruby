module Upmin
  module Server
    class SingletonClient

      def SingletonClient.root_url
        return Client.root_url
      end

      def SingletonClient.retrieve
        return @singleton if defined?(@singleton)
        return retrieve_refresh
      end

      def SingletonClient.retrieve_refresh
        resp = Typhoeus.get(
          root_url,
          followlocation: true,
          params: {
            api_key: Upmin.api_key
          }
        )
        return @singleton = self.new(JSON.parse(resp.body))
      end

      # Basically treat it as a simplified hash with a few methods declared.
      def initialize(values)
        @values = {}
        values.each do |k, v|
          @values[k.to_sym] = v
        end
      end

      def [](k)
        return @values[k.to_sym]
      end

      def []=(k, v)
        @values[k.to_sym] = v
      end

      def keys
        return @values.keys
      end

      def values
        return @values.values
      end

    end
  end
end
