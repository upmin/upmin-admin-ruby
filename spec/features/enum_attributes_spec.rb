require 'spec_helper'

feature 'Enum Attributes' do

  scenario 'Creating a new model' do
    visit '/upmin/m/UserWithRoleEnum/new'
    choose 'Admin'
    expect { click_button("Create") }.to(change(UserWithRoleEnum, :count))
    expect(page).to(have_selector("input#user_with_role_enum_role_admin[checked='checked']"))
  end

  scenario 'Updating a model' do
    user = UserWithRoleEnum.create!
    visit "/upmin/m/UserWithRoleEnum/i/#{user.id}"
    choose 'Admin'
    click_button("Save")
    expect(page).to(have_selector("input#user_with_role_enum_role_admin[checked='checked']"))
    user.reload
    expect(user.role).to eq 'admin'
  end

end
