import consumer from "./consumer"

export default function createConversationChannel(conversationId) {
  let typingTimeout = null;
  const currentUserId = document.querySelector('meta[name="current-user-id"]')?.content;

  return consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      received(data) {
        if (data.typing) {
          if (String(data.typing.user_id) === String(currentUserId)) return;

          const indicator = document.getElementById("typing-indicator");
          if (indicator) {
            indicator.innerText = `${data.typing.username} is typing...`;
            if (typingTimeout) clearTimeout(typingTimeout);
            typingTimeout = setTimeout(() => {
              const input = document.querySelector('[data-typing-target="input"]');
              if (!input || input.value.trim() === "") {
                indicator.innerText = "";
              }
            }, 2000);
          }
        }
      }
    }
  );
}
