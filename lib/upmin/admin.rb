require "upmin"
require "upmin/engine"

require "upmin/klass"
require "upmin/model"

# Monkey patch code into rails
require "upmin/railties/active_record"
require "upmin/railties/render"
require "upmin/railties/render_helpers"
require "upmin/railtie"

# gems and stuff we use
require "jquery-rails"
require "ransack"
require "haml"
require "sass-rails"
require "kaminari"

module Upmin
  module Admin
  end
end
