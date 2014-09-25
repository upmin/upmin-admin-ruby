class AdminProduct < Upmin::Model
  attributes :name, :short_desc, :price, :manufacturer, :free_shipping

  action :update_price

  def update_price(price)
    model.price = price
    model.save!
  end

end
