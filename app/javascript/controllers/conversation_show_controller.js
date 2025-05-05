import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "onlineUsersBtn", "onlineUsersPopup", "emojiBtn", "emojiPicker", "chatInput"]

  connect() {
    this.scrollMessagesToBottom()
    this.setupOnlineUsersPopup()
    this.setupEmojiPicker()
    this.setupImageLoading()
  }

  scrollMessagesToBottom() {
    if (this.messagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  setupOnlineUsersPopup() {
    let popupVisible = false

    this.onlineUsersBtnTarget.addEventListener("click", (e) => {
      e.preventDefault()
      e.stopPropagation()
      popupVisible = !popupVisible
      this.onlineUsersPopupTarget.style.display = popupVisible ? "block" : "none"
      
      if (popupVisible) {
        const rect = this.onlineUsersBtnTarget.getBoundingClientRect()
        this.onlineUsersPopupTarget.style.left = rect.left + "px"
        this.onlineUsersPopupTarget.style.top = (rect.bottom + window.scrollY + 5) + "px"
      }
    })

    document.addEventListener("click", (e) => {
      if (!this.onlineUsersBtnTarget.contains(e.target) && !this.onlineUsersPopupTarget.contains(e.target)) {
        this.onlineUsersPopupTarget.style.display = "none"
        popupVisible = false
      }
    })
  }

  setupEmojiPicker() {
    if (this.emojiBtnTarget && this.emojiPickerTarget && this.chatInputTarget) {
      // Create and initialize the emoji picker
      const picker = document.createElement('emoji-picker')
      this.emojiPickerTarget.appendChild(picker)

      // Handle emoji selection
      picker.addEventListener('emoji-click', event => {
        const emoji = event.detail.unicode
        const start = this.chatInputTarget.selectionStart
        const end = this.chatInputTarget.selectionEnd
        const text = this.chatInputTarget.value
        this.chatInputTarget.value = text.slice(0, start) + emoji + text.slice(end)
        this.chatInputTarget.focus()
        this.chatInputTarget.selectionStart = this.chatInputTarget.selectionEnd = start + emoji.length

        // Trigger input event to update typing status
        const inputEvent = new Event('input', { bubbles: true })
        this.chatInputTarget.dispatchEvent(inputEvent)
      })

      // Hide picker if clicking outside
      document.addEventListener("click", (e) => {
        if (this.emojiPickerTarget.style.display === "block" && 
            !this.emojiPickerTarget.contains(e.target) && 
            e.target !== this.emojiBtnTarget) {
          this.emojiPickerTarget.style.display = "none"
        }
      })
    }
  }

  toggleEmojiPicker(e) {
    e.preventDefault()
    e.stopPropagation()
    
    if (this.emojiPickerTarget.style.display === "none") {
      const rect = this.emojiBtnTarget.getBoundingClientRect()
      this.emojiPickerTarget.style.left = rect.left + "px"
      this.emojiPickerTarget.style.top = (rect.bottom + window.scrollY + 5) + "px"
      this.emojiPickerTarget.style.display = "block"
    } else {
      this.emojiPickerTarget.style.display = "none"
    }
  }

  setupImageLoading() {
    this.hideChatImages()
    this.showChatImagesWithDelay()
  }

  hideChatImages() {
    document.querySelectorAll('.chat-image').forEach(img => {
      img.style.visibility = 'hidden'
    })
  }

  showChatImagesWithDelay(delay = 1200) {
    setTimeout(() => {
      document.querySelectorAll('.chat-image').forEach(img => {
        img.style.visibility = 'visible'
        if (img.src) {
          img.src = img.src
        }
      })
    }, delay)
  }

  // Turbo events
  beforeStreamRender() {
    this.scrollMessagesToBottom()
    this.hideChatImages()
    this.showChatImagesWithDelay()
  }

  beforeVisit() {
    if (this.emojiPickerTarget) {
      this.emojiPickerTarget.style.display = "none"
    }
    if (this.onlineUsersPopupTarget) {
      this.onlineUsersPopupTarget.style.display = "none"
    }
  }
} 