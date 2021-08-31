# frozen_string_literal: true

feature 'User can view a list of his rewards', "
  In order to find out what awards I have
  As an authenticated user
  I'd like to be able to view a list of my rewards
" do
  given(:user) { create(:user) }
  given(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.png')) }

  background { sign_in(user) }

  scenario 'user views all his rewards' do
    create_list(:reward, 3, owner: user, image: image)

    visit rewards_path
    expect(page).to have_content 'My Rewards'
    expect(page).to have_content 'Reward name', count: 3
    expect(page).to have_selector "img[src=\"#{url_for(user.rewards.first.image).delete_prefix('http://www.example.com')}\"]"
    expect(page).to have_selector "img[src=\"#{url_for(user.rewards.second.image).delete_prefix('http://www.example.com')}\"]"
    expect(page).to have_selector "img[src=\"#{url_for(user.rewards.last.image).delete_prefix('http://www.example.com')}\"]"
  end
end
