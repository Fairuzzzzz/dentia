import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    const isDark = localStorage.getItem("darkMode") === "true"
    document.documentElement.classList.toggle("dark", isDark)
    if (this.hasToggleTarget) {
      this.toggleTarget.checked = isDark
    }
  }

  toggle(event) {
    const isDark = event.currentTarget.checked
    document.documentElement.classList.toggle("dark", isDark)
    localStorage.setItem("darkMode", isDark)
  }
}
