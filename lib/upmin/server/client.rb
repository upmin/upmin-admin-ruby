module Upmin
  module Server
    class Client

      def Client.root_url
        return "https://www.upmin.com/api"
      end

      def Client.all
        return @all if defined?(@all)
        return all_refresh
      end

      def Client.all_refresh
        resp = Typhoeus.get(
          root_url,
          followlocation: true,
          params: {
            api_key: Upmin.api_key
          }
        )
        return @all = JSON.parse(resp.body).map{ |data| self.new(data) }
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
