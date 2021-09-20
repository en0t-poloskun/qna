# frozen_string_literal: true

describe AnswerNotificationsJob, type: :job do
  let(:answer) { create(:answer) }
  let(:service) { instance_double('AnswerNotificationsService') }

  before do
    allow(AnswerNotificationsService).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotificationsService#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    described_class.perform_now(answer)
  end
end
