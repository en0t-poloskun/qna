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

  describe '#change_owner' do
    let(:old_owner) { create(:user) }
    let(:new_owner) { create(:user) }
    let(:reward) { create(:reward, owner: old_owner) }

    it 'changes owner' do
      reward.change_owner(new_owner)
      reward.reload
      expect(reward.owner).to eq new_owner
    end
  end
end
