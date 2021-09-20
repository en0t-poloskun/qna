# frozen_string_literal: true

class AnswerNotificationsJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotificationsService.new.send_notification(answer)
  end
end
