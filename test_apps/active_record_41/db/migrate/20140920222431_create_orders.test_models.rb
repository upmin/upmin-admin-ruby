# This migration comes from test_models (originally 20140807183757)
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :stripe_charge_id
      t.string :stripe_refund_id

      t.timestamps null: false
    end
  end
end
