class ProductOrder
  include DataMapper::Resource

  property :id, Serial, key: true

  property :product_id, Integer
  property :order_id, Integer
  property :quantity, Integer
  property :purchase_price, Decimal

  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }

  belongs_to :order, model: Order, child_key: [:order_id]
  belongs_to :product, model: Product, child_key: [:product_id]
end
