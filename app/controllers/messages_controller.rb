# frozen_string_literal: true

class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_conversation, except: [:mark_read]

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user
    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @conversation }
      end
    else
      render 'conversations/show', status: :unprocessable_entity
    end
  end

  def show
    @conversation.messages.where.not(user: current_user).find_each do |message|
      receipt = message.message_receipts.find_by(user: current_user)
      receipt.update(read: true) if receipt && !receipt.read?
    end
  end

  def mark_read
    @message = Message.find(params[:id])
    receipt = @message.message_receipts.find_by(user: current_user)
    if receipt && !receipt.read?
      receipt.update(read: true)
      @message.conversation.users.each do |user|
        @message.broadcast_replace_to(
          [@message.conversation, user],
          target: dom_id(@message),
          partial: 'messages/message',
          locals: { message: @message, current_user: user }
        )
      end
    end
    head :ok
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :media)
  end
end
