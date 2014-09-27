module Upmin::DataMapper
  class Query < Upmin::Query

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
      # TODO(jon): Implement this.
    end

    def paginated_results
      # TODO(jon): Implement this.
    end


    private


  end
end
