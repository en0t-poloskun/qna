# frozen_string_literal: true

feature 'User can view the question and the answers to it', "
  In order to get answer for question
  As an user
  I'd like to be able to view the question with available answers
" do
  scenario 'view the question with available answers', js: true do
    question = create(:question)
    question.answers = create_list(:answer, 3)

    visit question_path(question)

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
    expect(page).to have_content 'Answer body', count: 3
  end
end
