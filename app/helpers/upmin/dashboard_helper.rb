module Upmin
  module DashboardHelper

    # call the by_<time> method according to the time range of the model
    def group_by_best_fit(model, limit = 30)
      @model = model
      return send "by_#{group_by model, limit}"
    end

    # Selects the time period with no more than <limit> entries
    def group_by(model, limit = 30)
      seconds = date_range_to_seconds(date_range(model))

      # if seconds < limit
      #   return 'second'
      # elsif seconds/1.minute < limit
      #   return 'minute'
      # elsif seconds/1.hour < limit
      #   return 'hour'
      if seconds/1.day < limit
        return 'day'
      elsif seconds/1.week < limit
        return 'week'
      elsif seconds/1.month < limit
        return 'month'
      else
        return 'year'
      end
    end

    #
    # Date range manipulation
    #
    def date_range_to_seconds(range)
      return range.last - range.first
    end

    def date_range(model)
      return first_date_of(model)..last_date_of(model)
    end

    def first_date_of(model)
      return model.order('date(created_at) ASC').first.try(:created_at) || Time.now
    end

    def last_date_of(model)
      return model.order('date(created_at) ASC').last.try(:created_at) || Time.now
    end

    #
    # Group by
    #
    def by_day
      dates = @model.where.not('created_at' => nil).group('date(created_at)').order('date(created_at) ASC').count
      # Convert sqlite String date keys to Date keys
      dates.map! { |k, v| [Date.parse(k), v] } if dates.keys.first.is_a? String
      return dates
    end

    def by_week
      result = Hash.new(0)
      by_day.each_with_object(result) { |i, a|  a[i[0].beginning_of_week.strftime] += i[1] }
      return result
    end

    def by_month
      return group_by_strftime('%b %Y')
    end

    def by_year
      return group_by_strftime('%Y')
    end

    #
    # Aggregate by
    #
    def by_day_of_week
      template = Hash[Date::ABBR_DAYNAMES.map {|x| [x, 0]}]
      return group_by_strftime('%a', template)
    end

    def by_week_of_year
      return group_by_strftime('%W')
    end

    def by_month_of_year
      template = Hash[Date::ABBR_MONTHNAMES.map {|x| [x, 0]}]
      template.shift
      return group_by_strftime( '%b', template)
    end

    def group_by_strftime(filter, result = Hash.new(0))
      by_day.each_with_object(result) { |i, a|  a[i[0].strftime(filter)] += i[1] }
      return result
    end

  end
end
