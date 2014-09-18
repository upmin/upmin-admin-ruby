# encoding: UTF-8
require 'spec_helper'
require 'test_app/active_record/seeders/all_seeder'

feature('Search') do
  background do
    AllSeeder.seed
  end

  scenario("pagination") do
    visit('/upmin/m/User')

    puts User.all.as_json
    puts "html=#{page.html}"
    page.save_and_open_page

    # Make sure some basic pagination exits
    within('.pagination') do
      within('.current') do
        page.should(have_content('1'))
      end

      page.should(have_content('Next'))
      click_link('Next')
    end

    within('.pagination') do
      within('.current') do
        page.should(have_content('2'))
      end

      page.should(have_content('Next'))
      page.should(have_content('Prev'))

      click_link('3')
    end

    within('.pagination') do
      within('.current') do
        page.should(have_content('3'))
      end
    end

  end

  # scenario 'navigating by pagination links' do
  #   visit '/users'

  #   within 'nav.pagination' do
  #     within '.page.current' do
  #       page.should have_content '1'
  #     end
  #     pagination.should
  #     within 'span.next' do
  #       click_link 'Next ›'
  #     end
  #   end

  #   within 'nav.pagination' do
  #     within 'span.page.current' do
  #       page.should have_content '2'
  #     end
  #     within 'span.last' do
  #       click_link 'Last »'
  #     end
  #   end

  #   within 'nav.pagination' do
  #     within 'span.page.current' do
  #       page.should have_content '4'
  #     end
  #     within 'span.prev' do
  #       click_link '‹ Prev'
  #     end
  #   end

  #   within 'nav.pagination' do
  #     within 'span.page.current' do
  #       page.should have_content '3'
  #     end
  #     within 'span.first' do
  #       click_link '« First'
  #     end
  #   end

  #   within 'nav.pagination' do
  #     within 'span.page.current' do
  #       page.should have_content '1'
  #     end
  #   end
  # end
end
