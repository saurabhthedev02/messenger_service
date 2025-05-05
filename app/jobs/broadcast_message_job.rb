# frozen_string_literal: true

class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find_by(id: message_id)
    return unless message

    message.replace_message_with_attachment
  end
end
