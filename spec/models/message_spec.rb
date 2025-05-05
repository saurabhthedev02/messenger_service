# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
    it { should have_many(:message_receipts).dependent(:destroy) }
    it { should have_one_attached(:media) }
  end

  describe 'callbacks' do
    let(:conversation) { create(:conversation, :with_users) }
    let(:sender) { conversation.users.first }
    let(:recipient) { conversation.users.last }

    it 'creates message receipts for other users in the conversation' do
      message = create(:message, conversation: conversation, user: sender)

      expect(message.message_receipts.count).to eq(1)
      expect(message.message_receipts.first.user).to eq(recipient)
      expect(message.message_receipts.first.read).to be_falsey
    end
  end

  describe 'methods' do
    let(:conversation) { create(:conversation, :with_users) }
    let(:message) { create(:message, conversation: conversation, user: conversation.users.first) }
    let(:recipient) { conversation.users.last }

    describe '#mark_as_read' do
      it 'marks the message receipt as read for the given user' do
        receipt = message.message_receipts.find_by(user: recipient)
        expect { message.mark_as_read(recipient) }
          .to change { receipt.reload.read }
          .from(false)
          .to(true)
      end
    end

    describe '#replace_message_with_attachment' do
      it 'broadcasts the message with attachment' do
        expect(message).to receive(:broadcast_replace_to)
          .with(conversation,
                target: "message_#{message.id}",
                partial: 'messages/message',
                locals: { message: message, current_user: conversation.users.first })

        message.replace_message_with_attachment
      end
    end
  end
end
