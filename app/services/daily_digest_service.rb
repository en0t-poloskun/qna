# frozen_string_literal: true

class DailyDigestService
  def send_digest
    questions = Question.created_yesterday.to_a

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
