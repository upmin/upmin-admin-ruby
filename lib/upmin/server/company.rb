module Upmin
  module Server
    class Company < Client

      def Company.root_url
        return "#{Client.root_url}/companies"
      end

    end
  end
end
