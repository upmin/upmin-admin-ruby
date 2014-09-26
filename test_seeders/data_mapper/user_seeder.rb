# Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |f| require f }

class UserSeeder
  def UserSeeder.seed
    file = File.new("#{File.dirname(__FILE__)}/../names.json")
    json_names = JSON.parse(File.read(file))

    first_names = json_names["first_names"]
    last_names = json_names["last_names"]
    (1..100).each do |i|
      first_name = first_names[rand(first_names.length)]
      last_name = last_names[rand(last_names.length)]
      if i % 3 == 0
        email = "#{first_name[0]}.#{last_name}#{i % 100}@gmail.com"
      elsif i % 3 == 1
        email = "#{first_name}#{last_name}@gmail.com"
      else
        email = "#{first_name}#{last_name}@yahoo.com"
      end

      u = User.new()
      u.name = "#{first_name} #{last_name}"
      u.email = email
      u.stripe_card_id = random_id(8)
      u.save!
    end
  end

  def UserSeeder.random_id(length = 8)
    charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    word = ""
    (1..length).each do |i|
      word += charset[rand(charset.length)]
    end
    return word
  end
end
