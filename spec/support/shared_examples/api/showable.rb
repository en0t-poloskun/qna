# frozen_string_literal: true

shared_examples_for 'API Showable' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_json[attr]).to eq resource.send(attr).as_json
    end
  end
end
