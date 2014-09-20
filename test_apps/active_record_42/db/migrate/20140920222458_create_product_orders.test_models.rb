# This migration comes from test_models (originally 20140807183823)
class CreateProductOrders < ActiveRecord::Migration
  def change
    create_table :product_orders do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :purchase_price

      t.timestamps null: false
    end
  end
end
