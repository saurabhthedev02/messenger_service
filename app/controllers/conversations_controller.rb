# frozen_string_literal: true

class ConversationsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations.includes(:users)
      .order(updated_at: :desc)
      .page(params[:page])
      .per(10)
  end

  def show
    @messages = @conversation.messages.includes(:user).order(:created_at)
    mark_messages_as_read
  end

  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      @conversation.users << current_user if current_user
      redirect_to @conversation, notice: 'Conversation created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:name, :is_group)
  end

  def mark_messages_as_read
    unread_receipts = find_unread_receipts
    process_unread_receipts(unread_receipts)
  end

  def find_unread_receipts
    MessageReceipt.joins(:message)
      .where(messages: { conversation_id: @conversation.id })
      .where(user: current_user, read: false)
      .includes(:message)
  end

  def process_unread_receipts(receipts)
    receipts.find_each do |receipt|
      mark_receipt_as_read(receipt)
      broadcast_message_update(receipt.message)
      log_message_read(receipt.message)
    end
  end

  def mark_receipt_as_read(receipt)
    receipt.update(read: true)
  end

  def broadcast_message_update(message)
    message.broadcast_replace_to @conversation, target: dom_id(message)
  end

  def log_message_read(message)
    Rails.logger.info "Marking message #{message.id} as read for user #{current_user.id}"
  end
end
