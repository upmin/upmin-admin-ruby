Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |f| require f }

class ProductSeeder
  def ProductSeeder.seed
    file = File.new("#{File.dirname(__FILE__)}/products.json")
    json_array = JSON.parse(File.read(file))

    json_array.each_with_index do |json_product, index|
      break if index >= 100

      Product.create!(
        name: json_product["name"],
        short_desc: json_product["shortDescription"],
        best_selling_rank: json_product["bestSellingRank"],
        thumbnail: json_product["thumbnailImage"],
        price: json_product["salePrice"],
        manufacturer: json_product["manufacturer"],
        url: json_product["url"],
        product_type: json_product["type"],
        image: json_product["image"],
        category: json_product["category"],
        free_shipping: !json_product["shipping"].nil?
      )
    end
  end
end
