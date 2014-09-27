
FactoryGirl.define do
  factory(:user) do
    name "Jon Calhoun"
    email "joncalhoun@gmail.com"
    stripe_card_id "sc_123ab1123"
  end

  factory(:user_dif, class: User) do
    name "Not Jon Calhoun"
    email "notjoncalhoun@gmail.com"
    stripe_card_id "notsc_123ab1123"
  end

  factory(:product) do
    name "Office Home & Student 2013 - Windows"
    short_desc "Create, communicate and learn using streamlined touch, pen or keyboard commands"
    price "139.99"
    manufacturer "Microsoft"
    free_shipping true
  end
end
