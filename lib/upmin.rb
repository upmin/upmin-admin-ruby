require "upmin/engine"

require "upmin/klass"
require "upmin/model"

# Monkey patch code into rails
require "upmin/railties/active_record"
# require "upmin/active_record_relation"
require "upmin/railties/render"
require "upmin/railties/render_helpers"
require "upmin/railtie"

# gems and stuff we use
require "ransack"
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
      raise "Upmin API key is not set."
    end
  end

  # def Upmin.notify_upmin
  #   # TODO(jon): Add if prod check here (and maybe other spots?)
  #   resp = Typhoeus.get(init_url, followlocation: true, params: { api_key: Upmin.api_key })
  #   puts JSON.parse(resp.body)
  # end

end
