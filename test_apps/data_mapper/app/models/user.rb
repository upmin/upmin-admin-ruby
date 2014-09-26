class User
  include DataMapper::Resource

  property :id, Serial, key: true

  property :name, String
  property :email, String
  property :stripe_card_id, String
  property :admin, Boolean

  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }

  has n, :orders
end
