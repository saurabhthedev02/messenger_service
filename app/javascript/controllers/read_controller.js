import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { messageId: Number, status: Boolean }

  connect() {
    if (!this.statusValue) {
      if (!window[`markReadSent_${this.messageIdValue}`]) {
        window[`markReadSent_${this.messageIdValue}`] = true;
        setTimeout(() => {
          fetch(`/messages/${this.messageIdValue}/mark_read`, {
            method: "POST",
            headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content }
          });
        }, 200);
      }
    }
  }
}

