# encoding: UTF-8
require "spec_helper"

feature("Create a new model") do
  background do
    # Setup BG Stuff
  end

  scenario("with a valid user") do
    visit("/upmin/m/User/new")

    expected_user = build(:user)

    fill_in("user_name", with: expected_user.name)
    fill_in("user_email", with: expected_user.email)
    fill_in("user_stripe_card_id", with: expected_user.stripe_card_id)

    expect { click_button("Create") }.to(change(User, :count).by(1))

    expect(page).to(have_selector("input#user_name[value='#{expected_user.name}']"))
    expect(page).to(have_selector("input#user_email[value='#{expected_user.email}']"))
    expect(page).to(have_selector("input#user_stripe_card_id[value='#{expected_user.stripe_card_id}']"))
  end

  scenario("with an invalid user") do
    visit("/upmin/m/User/new")

    invalid_user = build(:user, email: "invalid")

    fill_in("user_name", with: invalid_user.name)
    fill_in("user_email", with: invalid_user.email)
    fill_in("user_stripe_card_id", with: invalid_user.stripe_card_id)

    expect { click_button("Create") }.not_to(change(User, :count))

    within(".alert.alert-danger") do
      expect(page).to(have_content("Customer was NOT created."))
    end

    within(".field_with_errors") do
      expect(page).to(have_selector("input#user_email"))
    end

    # Make sure the inputs have the values typed in.
    expect(page).to(have_selector("input#user_name[value='#{invalid_user.name}']"))
    expect(page).to(have_selector("input#user_email[value='#{invalid_user.email}']"))
    expect(page).to(have_selector("input#user_stripe_card_id[value='#{invalid_user.stripe_card_id}']"))
  end

  scenario("with a nil attribute") do
    product = build(:product)
    visit("/upmin/m/Product/new")

    check("product_name_is_nil")
    fill_in("product_short_desc", with: product.short_desc)
    fill_in("product_price", with: product.price)
    fill_in("product_manufacturer", with: product.manufacturer)

    expect { click_button("Create") }.to(change(Product, :count).by(1))

    box = find("#product_name_is_nil")
    expect(box).to(be_checked)

    created = Product.last
    expect(created.name).to(be_nil)
    expect(created.short_desc).to(eq(product.short_desc))
    expect(created.manufacturer).to(eq(product.manufacturer))
  end
end
