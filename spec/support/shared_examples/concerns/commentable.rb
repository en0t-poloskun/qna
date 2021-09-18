# frozen_string_literal: true

shared_examples_for 'commentable' do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
