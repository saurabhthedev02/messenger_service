# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_for Conversation.find(params[:conversation_id])
  end

  def unsubscribed
    PresenceService.mark_offline(current_user.id)
  end

  def typing(_data)
    ConversationChannel.broadcast_to(
      Conversation.find(params[:conversation_id]),
      { typing: { user_id: current_user.id, username: current_user.username } }
    )
  end
end
