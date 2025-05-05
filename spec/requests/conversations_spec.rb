# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Conversations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:conversation) { create(:conversation, :with_users) }
  let!(:conversation_user1) { create(:conversation_user, user: user, conversation: conversation) }
  let!(:conversation_user2) { create(:conversation_user, user: other_user, conversation: conversation) }

  before do
    sign_in(user)
  end

  describe 'GET /conversations' do
    it 'returns a successful response' do
      get conversations_path
      expect(response).to have_http_status(:success)
    end

    it 'displays user conversations' do
      get conversations_path
      expect(response.body).to include(conversation.name)
    end
  end

  describe 'GET /conversations/new' do
    it 'returns a successful response' do
      get new_conversation_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /conversations' do
    context 'with valid parameters' do
      it 'creates a new conversation' do
        expect do
          post conversations_path, params: {
            conversation: {
              name: 'New Conversation',
              user_ids: [other_user.id]
            }
          }
        end.to change(Conversation, :count).by(1)
        expect(response).to redirect_to(conversation_path(Conversation.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new conversation' do
        expect do
          post conversations_path, params: {
            conversation: {
              name: '',
              user_ids: [other_user.id]
            }
          }
        end.not_to change(Conversation, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /conversations/:id' do
    it 'returns a successful response' do
      get conversation_path(conversation)
      expect(response).to have_http_status(:success)
    end

    it 'marks messages as read' do
      message = create(:message, conversation: conversation, user: other_user)
      get conversation_path(conversation)
      expect(message.message_receipts.find_by(user: user).read).to be true
    end
  end
end
