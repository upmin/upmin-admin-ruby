module Upmin::DataMapper
  module Query

    def results
      return klass.model_class.all(prepared_search)
    end

    private

      def prepared_search
        return @prepared_search if defined?(@prepared_search)
        @prepared_search = {}
        if search_options
          search_options.each do |key, value|
            next if value.empty?

            if op = create_operator(key)
              @prepared_search[op] = value
            else
              raise InvalidSearchSuffix.new(key)
            end
          end
        end
        puts "prepared search"
        puts @prepared_search.inspect
        puts "end of prepared search"
        return @prepared_search
      end

      def create_operator(key)
        if m = key.to_s.match(/(.*)_(#{valid_suffixes.join("|")})/)
          target = m.captures.first
          operator = operator_for(m.captures.second)
          return DataMapper::Query::Operator.new(target, operator)
        else
          return nil
        end
      end

      def valid_suffixes
        return [
          :gteq,
          :lteq,
          :cont
        ]
      end

      def operator_for(suffix)
        op_map = {
          gteq: :gte,
          lteq: :lte,
          cont: :like
        }
        return op_map[suffix.to_sym]
      end



  end
end
