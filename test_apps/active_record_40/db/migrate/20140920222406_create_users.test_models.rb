# This migration comes from test_models (originally 20140807182247)
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :stripe_card_id

      t.timestamps null: false
    end
  end
end
