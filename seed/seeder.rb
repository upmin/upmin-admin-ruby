Dir["#{File.dirname(__FILE__)}/*_seeder.rb"].each { |f| require f }

class Seeder
  def Seeder.seed
    ProductSeeder.seed
    UserSeeder.seed
    OrderSeeder.seed
  end
end
