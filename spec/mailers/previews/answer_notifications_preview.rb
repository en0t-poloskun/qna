# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/answer_notifications
class AnswerNotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/answer_notifications/notification
  def notification
    AnswerNotificationsMailer.notification(User.first, Answer.first)
  end
end
