import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "target"]

  add() {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.targetTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    const wrapper = event.target.closest(this.data.get("wrapper-selector") || ".nested-field-wrapper")
    if (wrapper) {
      const destroyInput = wrapper.querySelector("input[name*='_destroy']")
      if (destroyInput) {
        destroyInput.value = "1"
        wrapper.style.display = "none"
      } else {
        wrapper.remove()
      }
    }
  }
}
