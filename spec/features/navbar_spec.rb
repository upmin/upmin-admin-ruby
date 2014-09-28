# encoding: UTF-8
require "spec_helper"

feature("Navbar") do
  background do
    # Setup BG Stuff
  end

  scenario("default models") do
    visit ("/upmin")

    within(".navbar ul.nav") do
      expect(page).to(have_selector("li", text: "Users"))
      expect(page).to(have_selector("li", text: "Products"))
      expect(page).to(have_selector("li", text: "Orders"))
      expect(page).to(have_selector("li", text: "Product Orders"))
      expect(page).to(have_selector("li", text: "Shipments"))

      click_link("Users")
    end

    expect(page).to(have_selector(".upmin-model", minimum: 10))
  end

  scenario("configged models") do
    Upmin.configure do |config|
      config.models = [:user, :product]
    end

    visit ("/upmin")

    within(".navbar ul.nav") do
      expect(page).to(have_selector("li", text: "Users"))
      expect(page).to(have_selector("li", text: "Products"))
      expect(page).not_to(have_selector("li", text: "Orders"))
      expect(page).not_to(have_selector("li", text: "Product Orders"))
      expect(page).not_to(have_selector("li", text: "Shipments"))

      click_link("Users")
    end

    expect(page).to(have_selector(".upmin-model", minimum: 10))

    # Reset this.
    Upmin.configuration = Upmin::Configuration.new
  end

end
