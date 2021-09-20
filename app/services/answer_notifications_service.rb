# frozen_string_literal: true

class AnswerNotificationsService
  def send_notification(answer)
    answer.question.subscribers.find_each(batch_size: 500) do |subscriber|
      AnswerNotificationsMailer.notification(subscriber, answer).deliver_later
    end
  end
end
