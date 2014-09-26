class Product
  include DataMapper::Resource

  property :id, Serial, key: true
  property :name, String
  property :short_desc, String
  property :best_selling_rank, Integer
  property :thumbnail, String
  property :price, Decimal
  property :manufacturer, String
  property :url, String
  property :product_type, String
  property :image, String
  property :category, String
  property :free_shipping, Boolean


  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }, required: true
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }, required: true

  has n, :product_orders
  has n, :orders, model: Order, child_key: [:id], parent_key: [:order_id], through: :product_orders
end
