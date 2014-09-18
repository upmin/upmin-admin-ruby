require 'test_app/active_record/seeders/product_seeder'
require 'test_app/active_record/seeders/user_seeder'
require 'test_app/active_record/seeders/order_seeder'

class AllSeeder
  def AllSeeder.seed
    ProductSeeder.seed
    UserSeeder.seed
    OrderSeeder.seed
  end
end
