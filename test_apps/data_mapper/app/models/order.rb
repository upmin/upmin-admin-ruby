class Order
  include DataMapper::Resource

  property :id, Serial, key: true

  property :user_id, Integer
  property :stripe_charge_id, String
  property :stripe_refund_id, String

  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }

  has n, :product_orders
  has n, :products, model: Product, child_key: [:id], parent_key: [:order_id], through: :product_orders
  has 1, :shipment
  belongs_to :user, model: User, child_key: [:user_id]
end
