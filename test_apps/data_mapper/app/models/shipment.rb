class Shipment
  include DataMapper::Resource

  property :id, Serial, key: true

  property :order_id, Integer
  property :price, Decimal
  property :carrier, String
  property :tracking_code, String
  property :delivered, Boolean
  property :est_delivery_date, DateTime

  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }

  belongs_to :order, model: Order, child_key: [:order_id]
end
