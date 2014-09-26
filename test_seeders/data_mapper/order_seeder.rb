# Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |f| require f }

class OrderSeeder
  def OrderSeeder.seed
    (1..200).each do |i|
      user = User.get(rand(User.count) + 1)

      order = Order.new
      order.user = user
      order.save!

      num_products = rand(4) + 1
      (1..num_products).each do |k|
        quantity = rand(4) + 1
        product = Product.get(rand(Product.count) + 1)

        po = ProductOrder.new
        po.order = order
        po.product = product
        po.quantity = quantity
        po.purchase_price = product.price
        po.save!
      end

      shipment = Shipment.new
      shipment.order = order
      shipment.price = (rand(1000) / 100.0) + 10.0
      shipment.carrier = [:ups, :usps, :fedex, :dhl][rand(4)]
      shipment.delivered = [true, true, false][rand(3)]
      shipment.est_delivery_date = random_date
      shipment.save!
    end
  end

  def OrderSeeder.random_date(ago = 60, from_now = 20)
    ago = (0..ago).to_a.map{|i| i.days.ago}
    from_now = (1..from_now).to_a.map{|i| i.days.ago}
    all = ago + from_now
    return all[rand(all.length)]
  end
end
