# frozen_string_literal: true

feature 'User can create best answer reward', "
  In order to reward user for the best answer
  As an question's author
  I'd like to be able to create a reward for question
" do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User creates reward when asks question' do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Reward name', with: 'Test reward'
    attach_file 'Image', "#{Rails.root}/spec/fixtures/ruby.png"

    click_on 'Ask'

    expect(page).to have_content 'This question gives a reward'
    expect(page).to have_content 'Test reward'
  end
end
