require_dependency "upmin/application_controller"

module Upmin
  class DashboardController < ApplicationController

    def index
      @models = Upmin::Model.all  - [AdminUser]
    end

  end
end
