# Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |f| require f }

class ProductSeeder
  def ProductSeeder.seed
    file = File.new("#{File.dirname(__FILE__)}/products.json")
    json_array = JSON.parse(File.read(file))

    json_array.each_with_index do |json_product, index|
      break if index >= 100

      product = Product.new
      product.name = json_product["name"]
      product.short_desc = json_product["shortDescription"]
      product.best_selling_rank = json_product["bestSellingRank"]
      product.thumbnail = json_product["thumbnailImage"]
      product.price = json_product["salePrice"]
      product.manufacturer = json_product["manufacturer"]
      product.url = json_product["url"]
      product.product_type = json_product["type"]
      product.image = json_product["image"]
      product.category = json_product["category"]
      product.free_shipping = !json_product["shipping"].nil?
      product.save
    end
  end
end
