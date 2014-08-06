require "upmin/engine"

require "upmin/model"

# Server Clients
require "upmin/server"
require "upmin/server/client"
require "upmin/server/company"
require "upmin/server/model"


require "upmin/active_record"
# require "upmin/active_record_relation"
require "upmin/railtie"

require "typhoeus"
require "haml"
require "sass-rails"

module Upmin

  def Upmin.api_key=(api_key)
    @@api_key = api_key
    # Upmin.notify_upmin
  end

  def Upmin.api_key
    if (defined? @@api_key)
      return @@api_key
    else
      raise "Jetty API key is not set."
    end
  end

  # def Upmin.notify_upmin
  #   # TODO(jon): Add if prod check here (and maybe other spots?)
  #   resp = Typhoeus.get(init_url, followlocation: true, params: { api_key: Upmin.api_key })
  #   puts JSON.parse(resp.body)
  # end

end
