# encoding: UTF-8
require "spec_helper"

feature("Delete an existing model") do
  background do
    # Setup BG Stuff
  end

  scenario("should see delete button with confirmation") do
    user = User.first
    updated_user = build(:user)

    visit("/upmin/m/User/i/#{user.id}")

    expect(page).to(have_selector("a[data-method='delete']"))
    expect(page).to(have_selector("a[data-confirm='Are you sure?']"))

  end

  scenario("should delete if confirmed") do
    user = User.first
    # updated_user = build(:user)

    visit("/upmin/m/User/i/#{user.id}")

    first('a.destroy').click

    #expect(page.driver.alert_messages.last).to eq 'Are you sure?'

    if defined?(DataMapper)
      expect(User.get(user.id)).to be_nil
    else
      expect(User.where(id: user.id)).not_to exist
    end

  end

end
