# encoding: UTF-8
require 'spec_helper'

feature('Search') do
  background do
    # Setup BG Stuff
  end

  scenario("pagination") do
    visit('/upmin/m/User')

    # Make sure some basic pagination exits
    within('.pagination') do
      within('.current') do
        expect(page).to(have_content('1'))
      end

      expect(page).to(have_content('Next'))
      click_link('Next')
    end

    within('.pagination') do
      within('.current') do
        expect(page).to(have_content('2'))
      end

      expect(page).to(have_content('Next'))
      expect(page).to(have_content('Prev'))

      click_link('3')
    end

    within('.pagination') do
      within('.current') do
        expect(page).to(have_content('3'))
      end
    end
  end

  scenario("search box") do
    visit('/upmin/m/User')
  end


end
