class AdminProduct < Upmin::Model
   # The attributes method overwrites default attributes shown for a model, and replaces them with the provided attributes. These don't all need to be editable, but as long as there is an :attr_name= method available upmin assumes that the attribute should be editable.
  attributes :name, :short_desc, :price, :manufacturer, :free_shipping


  # The actions method overwrites all actions and uses the provided list of models.
  actions :update_price

  # You can use custom methods inside of admin that are explicitly for admin pages. For example, you might want a method to update the price and automatically add a 10% markup.
  def update_price(price)
    model.price = price # * 1.10 # our markup is 10%
    model.save!
  end

end
