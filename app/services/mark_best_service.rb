# frozen_string_literal: true

class MarkBestService
  def initialize(answer, reward)
    @answer = answer
    @reward = reward
  end

  def call
    ActiveRecord::Base.transaction do
      @answer.question.change_best(@answer)
      @reward&.change_owner(@answer.author)
    end
  end
end
