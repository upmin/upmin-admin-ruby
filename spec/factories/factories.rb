
FactoryGirl.define do
  factory(:user) do
    name "Jon Calhoun"
    email "joncalhoun@gmail.com"
    stripe_card_id "sc_123ab1123"
  end
end
