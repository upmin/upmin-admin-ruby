# encoding: UTF-8
require "spec_helper"

feature("Creating a Model Views") do
  background do
    # Setup BG Stuff
  end

  scenario("New user") do
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

  scenario("Invalid user") do
    visit("/upmin/m/User/new")

    invalid_user = build(:user, email: "invalid")

    fill_in("user_name", with: invalid_user.name)
    fill_in("user_email", with: invalid_user.email)
    fill_in("user_stripe_card_id", with: invalid_user.stripe_card_id)

    expect { click_button("Create") }.not_to(change(User, :count))

    within(".alert.alert-danger") do
      expect(page).to(have_content("User was NOT created."))
    end

    within(".field_with_errors") do
      expect(page).to(have_selector("input#user_email"))
    end

    # Make sure the inputs have the values typed in.
    expect(page).to(have_selector("input#user_name[value='#{invalid_user.name}']"))
    expect(page).to(have_selector("input#user_email[value='#{invalid_user.email}']"))
    expect(page).to(have_selector("input#user_stripe_card_id[value='#{invalid_user.stripe_card_id}']"))
  end
end
