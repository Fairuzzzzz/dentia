import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list", "diagnosis"]

  connect() {
    this.listTarget.classList.add("hidden")
  }

  async search(event) {
    const query = event.currentTarget.value.trim()
    if (query.length < 2) {
      this.listTarget.classList.add("hidden")
      return
    }

    const response = await fetch(`/icd_codes/search?q=${encodeURIComponent(query)}`)
    const codes = await response.json()

    if (codes.length === 0) {
      this.listTarget.innerHTML = '<div class="px-3 py-2 text-sm text-gray-500">Tidak ditemukan</div>'
    } else {
      this.listTarget.innerHTML = codes.map(c => `
        <button type="button" data-action="click->icd-autocomplete#select"
          data-code="${c.code}" data-description="${c.description.replace(/"/g, "&quot;")}"
          class="w-full text-left px-3 py-2 hover:bg-teal-50 dark:hover:bg-gray-700 transition">
          <span class="font-mono text-xs text-teal-600">${c.code}</span>
          <span class="text-sm text-gray-700 dark:text-gray-300 ml-2">${c.description}</span>
        </button>
      `).join("")
    }

    this.listTarget.classList.remove("hidden")
  }

  select(event) {
    const code = event.currentTarget.dataset.code
    const description = event.currentTarget.dataset.description
    this.inputTarget.value = code
    if (this.hasDiagnosisTarget) {
      this.diagnosisTarget.value = description
    }
    this.listTarget.classList.add("hidden")
  }

  blur() {
    setTimeout(() => this.listTarget.classList.add("hidden"), 200)
  }
}
