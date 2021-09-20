# frozen_string_literal: true

describe DailyDigestJob, type: :job do
  let(:service) { instance_double('DailyDigestService') }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_digest' do
    expect(service).to receive(:send_digest)
    described_class.perform_now
  end
end
