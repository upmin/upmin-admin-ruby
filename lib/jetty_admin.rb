require "jetty_admin/engine"

require "jetty_admin/model"

# Server Clients
require "jetty_admin/server"
require "jetty_admin/server/client"
require "jetty_admin/server/company"
require "jetty_admin/server/model"


require "jetty_admin/active_record"
# require "jetty_admin/active_record_relation"
require "jetty_admin/railtie"

require "typhoeus"
require "haml"
require "sass-rails"

module JettyAdmin

  def JettyAdmin.api_key=(api_key)
    @@api_key = api_key
    # JettyAdmin.notify_jetty
  end

  def JettyAdmin.api_key
    if (defined? @@api_key)
      return @@api_key
    else
      raise "Jetty API key is not set."
    end
  end

  # def JettyAdmin.notify_jetty
  #   # TODO(jon): Add if prod check here (and maybe other spots?)
  #   resp = Typhoeus.get(init_url, followlocation: true, params: { api_key: JettyAdmin.api_key })
  #   puts JSON.parse(resp.body)
  # end

end
