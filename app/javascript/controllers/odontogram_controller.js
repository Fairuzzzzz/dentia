import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dataInput", "panel", "toothId", "statusSelect", "notesInput", "svg", "tooth"]

  connect() {
    this.teethData = this.parseTeethData()
    this.currentType = "dewasa"
    this.staged = null
    this.renderAll()

    const form = this.element.closest("form")
    if (form) {
      form.addEventListener("submit", () => this.saveData())
    }
  }

  parseTeethData() {
    try {
      return JSON.parse(this.dataInputTarget.value || "{}")
    } catch {
      return {}
    }
  }

  saveData() {
    this.dataInputTarget.value = JSON.stringify(this.teethData)
  }

  toggleType(event) {
    this.currentType = event.currentTarget.value
    this.selectedTooth = null
    this.panelTarget.classList.add("hidden")
    this.staged = null

    this.element.querySelectorAll(".dewasa-set, .anak-set").forEach(el => {
      const isActive = el.classList.contains(`${this.currentType}-set`)
      el.classList.toggle("hidden", !isActive)
    })

    this.renderAll()
  }

  selectTooth(event) {
    const id = event.currentTarget.dataset.toothId
    this.selectedTooth = id

    const saved = this.teethData[id] || { status: "normal", surfaces: [], notes: "" }
    this.staged = { ...saved, surfaces: [...saved.surfaces] }

    this.panelTarget.classList.remove("hidden")
    this.toothIdTarget.textContent = `Gigi ${id}`
    this.statusSelectTarget.value = this.staged.status
    this.notesInputTarget.value = this.staged.notes || ""

    this.renderAll()
    this.renderStagedSurfaces()
  }

  updateStatus(event) {
    if (!this.staged) return
    this.staged.status = event.currentTarget.value
    this.previewColor()
  }

  toggleSurface(event) {
    if (!this.staged) return
    const surface = event.currentTarget.dataset.surface
    const surfaces = this.staged.surfaces

    if (surfaces.includes(surface)) {
      this.staged.surfaces = surfaces.filter(s => s !== surface)
      event.currentTarget.classList.remove("bg-teal-100", "border-teal-500")
      event.currentTarget.classList.add("bg-white", "border-gray-300")
    } else {
      this.staged.surfaces.push(surface)
      event.currentTarget.classList.add("bg-teal-100", "border-teal-500")
      event.currentTarget.classList.remove("bg-white", "border-gray-300")
    }
  }

  updateNotes(event) {
    if (!this.staged) return
    this.staged.notes = event.currentTarget.value
  }

  acceptChanges() {
    if (!this.selectedTooth || !this.staged) return
    this.teethData[this.selectedTooth] = { ...this.staged, surfaces: [...this.staged.surfaces] }
    this.saveData()
    this.renderAll()
    this.panelTarget.classList.add("hidden")
    this.staged = null
    this.selectedTooth = null
    this.showToast("Data gigi berhasil disimpan")
  }

  showToast(message) {
    const el = document.createElement("div")
    el.className = "fixed bottom-4 right-4 bg-teal-600 text-white px-4 py-2 rounded-lg text-sm shadow-lg z-50 transition-all duration-300"
    el.textContent = message
    document.body.appendChild(el)
    setTimeout(() => { el.style.opacity = "0"; setTimeout(() => el.remove(), 300) }, 2000)
  }

  cancelChanges() {
    this.staged = null
    this.selectedTooth = null
    this.panelTarget.classList.add("hidden")
    this.renderAll()
  }

  previewColor() {
    if (!this.selectedTooth || !this.staged) return
    const toothEl = this.toothTargets.find(el => el.dataset.toothId === this.selectedTooth)
    if (!toothEl) return
    const rect = toothEl.querySelector("rect")
    if (rect) rect.setAttribute("fill", this.colorFor(this.staged.status))
  }

  renderAll() {
    this.toothTargets.forEach(el => {
      const id = el.dataset.toothId
      if (!id) return
      const tooth = this.teethData[id]
      const status = tooth?.status || "normal"
      const rect = el.querySelector("rect")
      if (rect) rect.setAttribute("fill", this.colorFor(status))
      el.classList.remove("ring-2", "ring-teal-500")
      if (id === this.selectedTooth) el.classList.add("ring-2", "ring-teal-500")
    })
  }

  renderStagedSurfaces() {
    if (!this.staged) return
    this.panelTarget.querySelectorAll("[data-surface]").forEach(el => {
      const surface = el.dataset.surface
      if (this.staged.surfaces.includes(surface)) {
        el.classList.add("bg-teal-100", "border-teal-500")
        el.classList.remove("bg-white", "border-gray-300")
      } else {
        el.classList.remove("bg-teal-100", "border-teal-500")
        el.classList.add("bg-white", "border-gray-300")
      }
    })
  }

  colorFor(status) {
    const colors = {
      normal: "#ffffff", caries: "#fbbf24", filled: "#9ca3af",
      missing: "#fbcfe8", crown: "#60a5fa", bridge: "#93c5fd",
      implant: "#34d399", root_canal: "#c084fc",
      fracture: "#fb923c", extraction_needed: "#f87171"
    }
    return colors[status] || "#ffffff"
  }
}
