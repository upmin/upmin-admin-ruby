# == Schema Information
#
# Table name: product_orders
#
#  id             :integer          not null, primary key
#  product_id     :integer
#  order_id       :integer
#  quantity       :integer
#  purchase_price :decimal(, )
#  created_at     :datetime
#  updated_at     :datetime
#

class ProductOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
end
