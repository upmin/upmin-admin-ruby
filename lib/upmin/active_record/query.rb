module Upmin::ActiveRecord
  module Query

    def results
      return klass.model_class.ransack(search_options).result(distinct: true)
    end

    private


  end
end
