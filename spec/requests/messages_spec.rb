# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:conversation) { create(:conversation, :with_users) }
  let!(:conversation_user1) { create(:conversation_user, user: user, conversation: conversation) }
  let!(:conversation_user2) { create(:conversation_user, user: other_user, conversation: conversation) }

  before do
    sign_in(user)
  end

  describe 'POST /conversations/:conversation_id/messages' do
    context 'with valid parameters' do
      it 'creates a new message' do
        expect do
          post conversation_messages_path(conversation), params: {
            message: {
              body: 'Hello, this is a test message'
            }
          }
        end.to change(Message, :count).by(1)
        expect(response).to redirect_to(conversation_path(conversation))
      end

      it 'broadcasts the message' do
        expect(ActionCable.server).to receive(:broadcast)
          .with(conversation.to_gid_param, /turbo-stream action="append" target="messages"/)
          .twice
        post conversation_messages_path(conversation), params: {
          message: {
            body: 'Hello, this is a test message'
          }
        }
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new message' do
        expect do
          post conversation_messages_path(conversation), params: {
            message: {
              body: ''
            }
          }
        end.not_to change(Message, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with media' do
      let(:file) { fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg') }

      it 'creates a message with media' do
        expect do
          post conversation_messages_path(conversation), params: {
            message: {
              body: 'Message with media',
              media: file
            }
          }
        end.to change(Message, :count).by(1)
        expect(Message.last.media).to be_attached
      end
    end
  end
end
