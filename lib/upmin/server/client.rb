module Upmin
  module Server
    class Client

      def Client.root_url
        return "http://localhost:3000/api"
      end

      def Client.all
        resp = Typhoeus.get(
          root_url,
          followlocation: true,
          params: {
            api_key: Upmin.api_key
          }
        )
        return JSON.parse(resp.body).map{ |data| self.new(data) }
      end

      def Client.find(id)
        # TODO(jon): Implement this.
        raise NotImplementedError
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
