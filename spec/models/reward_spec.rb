# frozen_string_literal: true

describe Reward, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:owner).optional }

  it { is_expected.to validate_presence_of :name }

  it 'have one attached file' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { is_expected.to validate_attached_of(:image) }

  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpeg', 'image/jpg') }
end
