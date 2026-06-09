import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    this.open = false
  }

  toggle() {
    this.open = !this.open
    if (this.open) {
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.overlayTarget.classList.remove("hidden")
      document.body.classList.add("overflow-hidden")
    } else {
      this.sidebarTarget.classList.add("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }
  }

  close() {
    this.open = false
    this.sidebarTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }
}
