require 'spec_helper'

feature 'Viewing a recipe', js: true do
  before do
    Recipe.create!(name: 'Baked Potato w/ Cheese',
                   instruction: 'nuke for 20 minutes')

    Recipe.create!(name: 'Baked Brussel Sprouts',
                   instruction: 'Slather in oil, and roast on high heat for 20 minutes')
  end
  scenario 'view on recipe' do
    visit '/'
    fill_in 'keywords', with: 'baked'
    click_on 'Search'

    click_on 'Baked Brussel Sprouts'

    expect(page).to have_content('Baked Brussel Sprouts')
    expect(page).to have_content('Slather in oil')

    click_on 'Back'

    expect(page).to     have_content('Baked Brussel Sprouts')
    expect(page).to_not have_content('Slather in oil')
  end
end