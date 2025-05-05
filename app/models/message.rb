# frozen_string_literal: true

class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :conversation
  belongs_to :user
  has_many :message_receipts, dependent: :destroy
  has_one_attached :media

  validates :body, presence: true, unless: -> { media.attached? }
  validates :media, presence: true, unless: -> { body.present? }

  after_create :create_receipts
  after_create_commit :broadcast_initial_message
  after_commit :broadcast_with_media, if: -> { media.attached? }
  after_create_commit do
    broadcast_append_to conversation, target: 'messages'
  end

  def mark_as_read(user)
    message_receipts.find_by(user: user)&.update!(read: true)
  end

  def replace_message_with_attachment
    current_user = Current.user || conversation.users.first

    broadcast_replace_to conversation,
                         target: dom_id(self),
                         partial: 'messages/message',
                         locals: { message: self, current_user: current_user }
  end

  private

  def broadcast_initial_message
    broadcast_append_to conversation, target: 'messages'
  end

  def broadcast_with_media
    BroadcastMessageJob.set(wait: 2.seconds).perform_later(id)
  end

  def create_receipts
    conversation.users.where.not(id: user_id).find_each do |recipient|
      message_receipts.create!(user: recipient, read: false)
    end
  end

  # def create_receipts
  #   conversation.users.each do |user|
  #     MessageReceipt.find_or_create_by!(message: self, user: user) do |receipt|
  #       receipt.delivered = (user == self.user)
  #       receipt.read = false
  #     end
  #   end
  # end
end
