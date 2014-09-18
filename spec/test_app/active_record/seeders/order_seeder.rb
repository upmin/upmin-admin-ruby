class OrderSeeder
  def OrderSeeder.seed
    (1..200).each do |i|
      user = User.find(rand(User.count) + 1)
      order = Order.create!(user: user)
      num_products = rand(4) + 1
      (1..num_products).each do |k|
        quantity = rand(4) + 1
        product = Product.find(rand(Product.count) + 1)
        po = ProductOrder.new(
          order: order,
          product: product,
          quantity: quantity,
          purchase_price: product.price
        )
        po.save!
      end

      order.build_shipment(
        price: (rand(1000) / 100.0) + 10.0,
        carrier: [:ups, :usps, :fedex, :dhl][rand(4)],
        delivered: [true, true, false][rand(3)],
        est_delivery_date: random_date
      ).save!
    end
  end

  def OrderSeeder.random_date(ago = 60, from_now = 20)
    ago = (0..ago).to_a.map{|i| i.days.ago}
    from_now = (1..from_now).to_a.map{|i| i.days.ago}
    all = ago + from_now
    return all[rand(all.length)]
  end
end
