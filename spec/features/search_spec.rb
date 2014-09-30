# encoding: UTF-8
require "spec_helper"

feature("Search Views") do
  background do
    # Setup BG Stuff
  end

  scenario("Nav Bar") do
    # it("TODO(jon): Write this test")
  end

  scenario("Page Entries Info") do
    visit("/upmin/m/User")

    # Make sure some basic page entries info exits
    within(".page_entries_info:first-of-type") do
      within("b:first-of-type") do
        expect(page).to(have_content("1 - 30"))
      end

      expect(page).to(have_content("of"))

      within("b:nth-of-type(2)") do
        expect(page).to(have_content("100"))
      end

      expect(page).to(have_content("in total"))
    end
  end

  scenario("Pagination") do
    visit("/upmin/m/User")

    # Make sure some basic pagination exits
    within(".pagination:first-of-type") do
      within(".current") do
        expect(page).to(have_content("1"))
      end

      expect(page).to(have_content("Next"))
      click_link("Next")
    end

    within(".pagination:nth-of-type(2)") do
      within(".current") do
        expect(page).to(have_content("2"))
      end

      expect(page).to(have_content("Next"))
      expect(page).to(have_content("Prev"))

      click_link("3")
    end

    within(".pagination:last-of-type") do
      within(".current") do
        expect(page).to(have_content("3"))
      end
    end
  end

  scenario("Search via integer") do
    visit("/upmin/m/Order")

    expect(page).to(have_selector("a.search-result-link", count: 30))

    fill_in("q_id_gteq", with: 1)
    fill_in("q_id_lteq", with: 5)
    click_button("Search")

    expect(page).to(have_selector("a.search-result-link", count: 5))
  end

  scenario("Search via string") do
    expected_user = User.first

    visit("/upmin/m/User")

    fill_in("q_name_cont", with: expected_user.name)
    click_button("Search")

    expect(page).to(have_selector("a.search-result-link", minimum: 1))
    expect(page).to(have_content(expected_user.name))
  end

  scenario("Search via string") do
    expected_user = User.first

    visit("/upmin/m/User")

    fill_in("q_name_cont", with: expected_user.name)
    click_button("Search")

    expect(page).to(have_selector("a.search-result-link", minimum: 1))
    expect(page).to(have_content(expected_user.name))
  end

end
