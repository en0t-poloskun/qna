# frozen_string_literal: true

feature 'User can view a list of questions', "
  In order to view existing questions
  As an user
  I'd like to be able to view a list of questions
" do
  scenario 'User views all questions' do
    create_list(:question, 3)

    visit questions_path

    expect(page).to have_content 'All Questions'
    expect(page).to have_content 'Question title', count: 3
    expect(page).to have_content 'Question body', count: 3
  end
end
