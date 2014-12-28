module Upmin::ActiveRecord
  module Query

    def results
      return klass.model_class.ransack(search_options).result(distinct: true).order(klass.sort_order)
    end

    private

  end
end
