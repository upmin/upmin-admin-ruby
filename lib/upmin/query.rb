module Upmin
  class Query

    attr_reader :klass
    attr_reader :search_options
    attr_reader :page
    attr_reader :per_page

    delegate(:underscore_name, to: :klass)

    def Query.new(klass, search_options = {}, options = {})
      if klass.data_mapper?
        return DataMapper::Query.new(klass, search_options, options)
      elsif klass.active_record?
        return ActiveRecord::Query.new(klass, search_options, options)
      else
        raise ArgumentError.new(klass)
      end
    end

    def initialize(klass, search_options = {}, options = {})
      @klass = klass
      @search_options = search_options
      @page = options[:page]
      @per_page = options[:per_page]
    end

    def results
      raise NotImplementedError
    end

    def paginated_results
      raise NotImplementedError
    end

    def upmin_results
      return @upmin_results if defined?(@upmin_results)
      @upmin_results = paginated_results.map{ |r| r.upmin_model }
      return @upmin_results
    end


    private

  end
end
