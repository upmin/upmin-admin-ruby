module JettyAdmin
  module ApplicationHelper
    def body_classes
      controller = "c-#{params[:controller].gsub(/_/, "-").gsub("jetty-admin/", "")}"
      action = "a-#{params[:action].gsub(/_/, "-")}"
      return [controller, action]
    end

    def body_data
      ret = {}
      ret[:controller] = params[:controller].camelize.gsub("JettyAdmin::", "")
      ret[:action] = params[:action].camelize
      return ret
    end
  end
end
