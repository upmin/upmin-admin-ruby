module Upmin
  class ActiveRecordQuery < Query

    def results
      return klass.ransack(search_options).result(distinct: true)
    end

    def paginated_results
      return @paginated_results if defined?(@paginated_results)
      if page && per_page
        pr = Upmin::Paginator.paginate(results, page, per_page)
      else
        pr = Upmin::Paginator.paginate(results)
      end
      @paginated_results = pr
      return @paginated_results
    end

    private

  end
end
