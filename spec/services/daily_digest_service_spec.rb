# frozen_string_literal: true

describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let!(:questions) { create_list(:question, 3, created_at: Date.yesterday) }

  it 'sends daily digest to all users' do
    User.find_each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }
    subject.send_digest
  end
end
