# frozen_string_literal: true

describe AnswerNotificationsService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, subscribers: users) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to all subscribers' do
    question.subscribers.each do |subscriber|
      expect(AnswerNotificationsMailer).to receive(:notification).with(subscriber, answer).and_call_original
    end
    subject.send_notification(answer)
  end
end
