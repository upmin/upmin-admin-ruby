# encoding: UTF-8
require 'spec_helper'
require 'test_app/active_record/seeders/all_seeder'

feature('Search') do
  background do
    AllSeeder.seed
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
end
