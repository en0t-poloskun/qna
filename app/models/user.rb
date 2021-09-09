# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, foreign_key: 'owner_id', dependent: :nullify
  has_many :votes, foreign_key: 'voter_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    id == resource.author_id
  end

  def voted?(resource)
    votes.find_by(votable: resource).present?
  end
end
