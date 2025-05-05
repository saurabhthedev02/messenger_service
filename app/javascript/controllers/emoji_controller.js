import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "picker", "input"]

  connect() {
    this.showPicker = this.showPicker.bind(this)
    this.hidePicker = this.hidePicker.bind(this)
    this.insertEmoji = this.insertEmoji.bind(this)

    this.buttonTarget.addEventListener("mousedown", this.showPicker)
    this.pickerTarget.addEventListener("mousedown", e => e.stopPropagation())
    this.pickerTarget.addEventListener("emoji-click", this.insertEmoji)
    document.addEventListener("mousedown", this.hidePicker)
    document.addEventListener("turbo:before-visit", this.hidePicker)
  }

  disconnect() {
    this.buttonTarget.removeEventListener("mousedown", this.showPicker)
    this.pickerTarget.removeEventListener("mousedown", e => e.stopPropagation())
    this.pickerTarget.removeEventListener("emoji-click", this.insertEmoji)
    document.removeEventListener("mousedown", this.hidePicker)
    document.removeEventListener("turbo:before-visit", this.hidePicker)
  }

  showPicker(e) {
    e.preventDefault()
    e.stopPropagation()
    if (this.pickerTarget.style.display === "none" || !this.pickerTarget.style.display) {
      const rect = this.buttonTarget.getBoundingClientRect()
      this.pickerTarget.style.left = rect.left + "px"
      this.pickerTarget.style.top = (rect.bottom + window.scrollY + 5) + "px"
      this.pickerTarget.style.display = "block"
    } else {
      this.pickerTarget.style.display = "none"
    }
  }

  hidePicker(e) {
    if (
      this.pickerTarget.style.display === "block" &&
      (!this.pickerTarget.contains(e?.target) && e?.target !== this.buttonTarget)
    ) {
      this.pickerTarget.style.display = "none"
    }
  }

  insertEmoji(event) {
    const emoji = event.detail.unicode
    const input = this.inputTarget
    const start = input.selectionStart
    const end = input.selectionEnd
    const text = input.value
    input.value = text.slice(0, start) + emoji + text.slice(end)
    input.focus()
    input.selectionStart = input.selectionEnd = start + emoji.length
    this.pickerTarget.style.display = "none"
    
    const inputEvent = new Event('input', { bubbles: true })
    input.dispatchEvent(inputEvent)
  }
}
