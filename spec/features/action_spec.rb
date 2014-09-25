# encoding: UTF-8
require "spec_helper"

feature("Performing an action") do
  background do
    # Setup BG Stuff
  end

  scenario("with an existing method") do
    user = User.first
    visit("/upmin/m/User/i/#{user.id}")

    within(".actions") do
      expect(page).to(have_selector("h4", text: "Issue coupon"))
      within("form.issue_coupon") do
        fill_in("issue_coupon_percent", with: "20")
        click_button("Submit")
      end
    end

    within(".alert.alert-info") do
      expect(page).to(have_content("CPN_FJALDKF01Z1"))
    end
  end

  scenario("without an optional parameter") do
    user = User.first
    visit("/upmin/m/User/i/#{user.id}")

    within(".actions") do
      expect(page).to(have_selector("h4", text: "Issue coupon"))
      within("form.issue_coupon") do
        check("issue_coupon_percent_is_nil")
        click_button("Submit")
      end
    end

    within(".alert.alert-info") do
      expect(page).to(have_content("CPN_FJALDKF01Z1"))
    end
  end

  scenario("with an admin only method") do
    product = Product.first
    visit("/upmin/m/Product/i/#{product.id}")

    new_price = "10.15"

    within(".actions") do
      expect(page).to(have_selector("h4", text: "Update price"))
      within("form.update_price") do
        fill_in("update_price_price", with: new_price)
        click_button("Submit")
      end
    end

    product.reload
    expect(product.price.to_s[0..4]).to(eq(new_price))
  end

end
