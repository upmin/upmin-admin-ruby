module Upmin
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc 'Creates an initializer file at config/initializers/upmin.rb and adds Upmin route to config/routes.rb'

      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'initializer.rb', 'config/initializers/upmin.rb'
      end

      def add_route
        route "mount Upmin::Engine => '/admin'"
      end

      def messages
        log "\n  # Global configuration can be edited in 'config/initializers/upmin.rb'\n"
        log "\n  # You can access Upmin at: '/admin'. Modify config/routes.rb if this conflicts with an existing route.\n\n"
      end

    end
  end
end
