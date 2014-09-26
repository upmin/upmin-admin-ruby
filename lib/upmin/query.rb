module Upmin
  class Query

    attr_reader :klass
    attr_reader :search_options
    attr_reader :page
    attr_reader :per_page

    delegate(:underscore_name, to: :klass)

    def Query.new(*args)
      unless args[0]
        raise ::ArgumentError.new("wrong number of arguments (#{args.length} for 1..3)")
      end
      unless args[0].superclass == Upmin::Model
        raise ArgumentError.new(args[0])
      end

      mc = args[0].model_class
      if mc.is_a?(DataMapper::Model)
        return DataMapperQuery.new(*args)
      elsif mc.superclass == ActiveRecord::Base
        return ActiveRecordQuery.new(*args)
      else
        raise ArgumentError.new(args[0])
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
