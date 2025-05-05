import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { conversationId: Number }
  static targets = ["input"]

  connect() {
    this.inputTarget.addEventListener("input", this.handleInput.bind(this))
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.handleInput.bind(this))
  }

  handleInput() {
    this.sendTyping()
    // If input is empty, clear the typing indicator immediately
    if (this.inputTarget.value.trim() === "") {
      const indicator = document.getElementById("typing-indicator")
      if (indicator) indicator.innerText = ""
    }
  }

  sendTyping() {
    if (window.App && window.App.cable) {
      const conversationId = this.conversationIdValue
      window.App.cable.subscriptions.subscriptions.forEach(sub => {
        if (sub.identifier.includes(`"conversation_id":"${conversationId}"`)) {
          sub.perform("typing", {})
        }
      })
    }
  }
}
