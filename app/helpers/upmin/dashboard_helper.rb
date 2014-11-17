module Upmin
  module DashboardHelper

    # call the by_<time> method according to the time range of the model
    def by_best_fit(model, limit = 30)
      model = Upmin::DashboardData.new(model)
      return model.send "by_#{model.group_by_range limit}"
    end

    def grouped_by(model, limit = 30)
      model = Upmin::DashboardData.new(model)
      return model.group_by_range limit
    end

  end
end
