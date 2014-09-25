module Upmin
  class Query

    attr_reader :klass
    attr_reader :search_options
    attr_reader :page
    attr_reader :per_page

    delegate(:underscore_name, to: :klass)

    def initialize(klass, search_options = {}, options = {})
      @klass = klass
      @search_options = search_options
      @page = options[:page]
      @per_page = options[:per_page]
    end

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

    def upmin_results
      return @upmin_results if defined?(@upmin_results)
      @upmin_results = paginated_results.map{ |r| r.upmin_model }
      return @upmin_results
    end

    private

  end
end
