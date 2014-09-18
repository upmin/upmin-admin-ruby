# == Schema Information
#
# Table name: products
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  short_desc        :string(255)
#  best_selling_rank :integer
#  thumbnail         :string(255)
#  price             :decimal(, )
#  manufacturer      :string(255)
#  url               :string(255)
#  product_type      :string(255)
#  image             :string(255)
#  category          :string(255)
#  free_shipping     :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders

  upmin_attributes :name, :short_desc, :price, :manufacturer, :free_shipping
end
