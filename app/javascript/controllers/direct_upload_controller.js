import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTarget.addEventListener("direct-upload:initialize", this.handleInitialize)
    this.inputTarget.addEventListener("direct-upload:start", this.handleStart)
    this.inputTarget.addEventListener("direct-upload:progress", this.handleProgress)
    this.inputTarget.addEventListener("direct-upload:error", this.handleError)
    this.inputTarget.addEventListener("direct-upload:end", this.handleEnd)
  }

  disconnect() {
    this.inputTarget.removeEventListener("direct-upload:initialize", this.handleInitialize)
    this.inputTarget.removeEventListener("direct-upload:start", this.handleStart)
    this.inputTarget.removeEventListener("direct-upload:progress", this.handleProgress)
    this.inputTarget.removeEventListener("direct-upload:error", this.handleError)
    this.inputTarget.removeEventListener("direct-upload:end", this.handleEnd)
  }

  handleInitialize(event) {
    const { target, detail } = event
    const { id, file } = detail
    console.log(`Starting upload of ${file.name}`)
  }

  handleStart(event) {
    const { target, detail } = event
    const { id, file } = detail
    console.log(`Upload started for ${file.name}`)
  }

  handleProgress(event) {
    const { target, detail } = event
    const { id, file, progress } = detail
    console.log(`Upload progress for ${file.name}: ${progress}%`)
  }

  handleError(event) {
    const { target, detail } = event
    const { id, file, error } = detail
    console.error(`Error uploading ${file.name}: ${error}`)
  }

  handleEnd(event) {
    const { target, detail } = event
    const { id, file } = detail
    console.log(`Upload completed for ${file.name}`)
  }
}
