module Upmin
  module Paginator

    def Paginator.paginate(chain, page = 1, per_page = 30)
      if defined?(WillPaginate)
        # Ignore per page for now - just use the will_paginate default
        return chain.paginate(page: page.to_i, per_page: per_page)
      else # Use Kaminari
        return chain.page(page).per(per_page)
      end
    end

  end
end
