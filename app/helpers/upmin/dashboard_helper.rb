module Upmin
  module DashboardHelper

    # call the appropriate by_??? method according to the time range of the model
    def group_by_best_fit(model)
      @model = model
      return send "by_#{group_by model}"
    end

    def group_by(model)
      seconds = date_range_to_seconds(date_range(model))

      #if seconds < 30          # 30 seconds
      #  return 'second'
      #elsif seconds < 1800     # 30 minutes
      #  return 'minute'
      #elsif seconds < 86400    # 24 hours
      #  return 'hour'
      if seconds < 2592000  # 30 days
        return 'day'
      elsif seconds < 15724800 # 26 weeks (~6 months)
        return 'week'
      elsif seconds < 93312000 # ~ 36 months
        return 'month'
      else
        return 'year'
      end
    end

    def date_range_to_seconds(range)
      return range.last - range.first
    end

    def date_range(model)
      return first_date_of(model)..last_date_of(model)
    end

    def first_date_of(model)
      return model.order("created_at ASC").first.try(:created_at) || Time.now
    end

    def last_date_of(model)
      return model.order("created_at ASC").last.try(:created_at) || Time.now
    end


    def by_day
      @model.group("date(created_at)").count
    end

    def by_week
      result = Hash.new(0)

      # map each "YYYY-MM-DD" key to beginning of week, then sum for same date.
      by_day.each_with_object(result) { |i, a|  a[Date.parse(i[0].to_s).beginning_of_week.strftime] += i[1] }
      return result
    end

    def by_month
      return group_by_filter('^\\d{4}-\\d{2}') # YYYY-MM
    end

    def by_year
      return group_by_filter('^\\d{4}') # YYYY
    end

    def group_by_filter(date_filter)
      result = Hash.new(0)

      # dates.map! {|date, count| [date.slice(/#{date_filter}/), count]}; dates.each { |date, count| by_date[date] += count }
      by_day.each_with_object(result) { |i, a|  a[i[0].to_s.slice(/#{date_filter}/)] += i[1] }
      return result
    end

    def by_day_of_week
      template = Hash[Date::ABBR_DAYNAMES.map {|x| [x, 0]}]
      return group_by_strftime(template, '%a')
    end

    def by_week_of_year
      template = Hash(0)
      return group_by_strftime(template, '%W')
    end

    def by_month_of_year
      template = Hash[Date::ABBR_MONTHNAMES.map {|x| [x, 0]}]
      template.shift
      return group_by_strftime(template, '%b')
    end

    def group_by_strftime(result, filter)
      by_day.each_with_object(result) { |i, a|  a[Date.parse(i[0].to_s).strftime(filter)] += i[1] }
      return result
    end

  end
end
