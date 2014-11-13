module Upmin
  module DashboardHelper

    # call the appropriate count_by_ method according to the time range of model objects
    def group_by_time(model)
      return model.send("count_by_#{group_by model}")
    end

    def group_by(model)
      range = time_range(model)
      seconds = time_range_to_seconds(range)

      if seconds < 30          # 30 seconds
        return 'second'
      elsif seconds < 1800     # 30 minutes
        return 'minute'
      elsif seconds < 86400    # 24 hours
        return 'hour'
      elsif seconds < 2592000  # 30 days
        return 'day'
      elsif seconds < 15724800 # 26 weeks (~6 months)
        return 'week'
      elsif seconds < 93312000 # ~ 36 months
        return 'month'
      else
        return 'year'
      end
    end

    def time_range_to_seconds(range)
      return range.last - range.first
    end

    def time_range(model)
      return first_time_of(model)..last_time_of(model)
    end

    def first_time_of(model)
      return model.order("created_at ASC").first.try(:created_at) || Time.now
    end

    def last_time_of(model)
      return model.order("created_at ASC").last.try(:created_at) || Time.now
    end

  end
end
