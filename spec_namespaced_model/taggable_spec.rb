# encoding: UTF-8
require "spec_helper"

feature("Taggable Search Views") do
  background do
    # Setup BG Stuff
  end

  scenario("Acts As Taggable On Tags") do
    # acts as taggable crap isn't eager loaded for some reason, so go here first
    visit("/upmin/m/ActsAsTaggableOn::Tag")

    expect(page).to(have_selector("a.search-result-link", count: 1))

    visit("/upmin/m/ActsAsTaggableOn::Tag/i/#{ActsAsTaggableOn::Tag.first.id}")
    expect(page).to(have_selector("h3", text: "Acts As Taggable On Tag # 1"))
  end

end
