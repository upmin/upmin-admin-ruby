# encoding: UTF-8
require "spec_helper"

feature("Update an existing model") do
  background do
    # Setup BG Stuff
  end

  scenario("with valid order info") do
    user = User.first
    updated_user = build(:user)

    visit("/upmin/m/User/i/#{user.id}")

    fill_in("user_name", with: updated_user.name)
    fill_in("user_email", with: updated_user.email)
    fill_in("user_stripe_card_id", with: updated_user.stripe_card_id)

    click_button("Save")

    expect(page).to(have_selector("input#user_name[value='#{updated_user.name}']"))
    expect(page).to(have_selector("input#user_email[value='#{updated_user.email}']"))
    expect(page).to(have_selector("input#user_stripe_card_id[value='#{updated_user.stripe_card_id}']"))

    user.reload
    expect(user.name).to(eq(updated_user.name))
    expect(user.email).to(eq(updated_user.email))
    expect(user.stripe_card_id).to(eq(updated_user.stripe_card_id))
  end

  scenario("with invalid user info") do
    user = create(:user_dif)
    invalid_user = build(:user, email: "invalid")

    visit("/upmin/m/User/i/#{user.id}")

    fill_in("user_name", with: invalid_user.name)
    fill_in("user_email", with: invalid_user.email)
    fill_in("user_stripe_card_id", with: invalid_user.stripe_card_id)

    click_button("Save")

    within(".alert.alert-danger") do
      expect(page).to(have_content("User was NOT updated."))
      expect(page).to(have_selector("li", text: /email/i))
    end

    within(".field_with_errors") do
      expect(page).to(have_selector("input#user_email"))
    end

    expect(page).to(have_selector("input#user_name[value='#{invalid_user.name}']"))
    expect(page).to(have_selector("input#user_email[value='#{invalid_user.email}']"))
    expect(page).to(have_selector("input#user_stripe_card_id[value='#{invalid_user.stripe_card_id}']"))

    user.reload
    expect(user.name).not_to(eq(invalid_user.name))
    expect(user.email).not_to(eq(invalid_user.email))
    expect(user.stripe_card_id).not_to(eq(invalid_user.stripe_card_id))

  end

  scenario("with a nil attribute") do
    product = Product.first
    visit("/upmin/m/Product/i/#{product.id}")

    check("product_name_is_nil")
    click_button("Save")

    box = find("#product_name_is_nil")
    expect(box).to(be_checked)

    product.reload
    expect(product.name).to(be_nil)
  end
end
