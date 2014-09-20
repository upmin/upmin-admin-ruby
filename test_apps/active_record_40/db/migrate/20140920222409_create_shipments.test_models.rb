# This migration comes from test_models (originally 20140807184427)
class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :order_id
      t.decimal :price
      t.string :carrier
      t.string :tracking_code
      t.boolean :delivered
      t.datetime :est_delivery_date

      t.timestamps null: false
    end
  end
end
