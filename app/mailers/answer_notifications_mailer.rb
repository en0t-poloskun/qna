# frozen_string_literal: true

class AnswerNotificationsMailer < ApplicationMailer
  def notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: 'New answer'
  end
end
