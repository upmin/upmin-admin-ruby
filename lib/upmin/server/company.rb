module Upmin
  module Server
    class Company < SingletonClient

      def Company.root_url
        return "#{SingletonClient.root_url}/company"
      end

      def Company.algolia_creds
        retrieve.algolia_creds
        puts "Found #{retrieve.algolia_creds}"
        return retrieve.algolia_creds
      end

      def algolia_creds
        return {
          api_key: self[:algolia_key],
          index: "c#{self[:id]}"
        }
      end

    end
  end
end
