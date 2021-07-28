# frozen_string_literal: true

feature 'User can view a list of questions', "
  In order to view existing questions
  As an user
  I'd like to be able to view a list of questions
" do
  scenario 'User views all questions' do
    2.times { create(:question) }

    visit questions_path

    expect(page).to have_content 'All Questions'
    expect(page).to have_content 'Question1'
    expect(page).to have_content 'Question2'
    expect(page).to have_content 'MyText'
  end
end
