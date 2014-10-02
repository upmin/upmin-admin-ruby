
module Upmin::Railties
  module Paginator

    def up_paginate(scope, options = {}, &block)
      if defined?(WillPaginate)
        options[:renderer] = BootstrapPagination::Rails if defined?(BootstrapPagination::Rails)
        return will_paginate(scope, options)
      else # Use Kaminari
        return paginate(scope, options, &block)
      end
    end

  end
end
