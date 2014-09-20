class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.text :short_desc
      t.integer :best_selling_rank
      t.string :thumbnail
      t.decimal :price
      t.string :manufacturer
      t.string :url
      t.string :product_type
      t.string :image
      t.string :category
      t.boolean :free_shipping

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :stripe_card_id
      t.boolean :stripe_card_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.string :stripe_charge_id
      t.string :stripe_refund_id

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

class CreateProductOrders < ActiveRecord::Migration
  def self.up
    create_table :product_orders do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :purchase_price

      t.timestamps
    end
  end

  def self.down
    drop_table :product_orders
  end
end

class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.integer :order_id
      t.decimal :price
      t.string :carrier
      t.string :tracking_code
      t.boolean :delivered
      t.datetime :est_delivery_date

      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end

class AllTables
  def self.up
    CreateProducts.up
    CreateUsers.up
    CreateOrders.up
    CreateProductOrders.up
    CreateShipments.up
  end

  def self.down
    CreateProducts.down
    CreateUsers.down
    CreateOrders.down
    CreateProductOrders.down
    CreateShipments.down
  end

end

ActiveRecord::Migration.verbose = false
