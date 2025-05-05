// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import createConversationChannel from "./channels/conversation_channel"

document.addEventListener("turbo:load", () => {
  const conversationElement = document.getElementById("conversation-id");
  if (conversationElement) {
    const conversationId = conversationElement.dataset.conversationId;
    createConversationChannel(conversationId);
  }
});

