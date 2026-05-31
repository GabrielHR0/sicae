import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "panel", "label"]

  connect() {
    this.syncLabel()
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  toggle(event) {
    event.preventDefault()
    this.panelTarget.classList.toggle("hidden")
  }

  select(event) {
    event.preventDefault()

    const button = event.currentTarget
    this.inputTarget.value = button.dataset.categorySelectId
    this.buttonTarget.dataset.selectedValue = button.dataset.categorySelectLabel
    this.syncLabel()
    this.close()
  }

  close() {
    this.panelTarget.classList.add("hidden")
  }

  syncLabel() {
    const selected = this.options().find((option) => option.id === this.inputTarget.value)
    const text = selected ? selected.label : this.buttonTarget.dataset.placeholder || "Selecione uma categoria"
    this.labelTarget.textContent = text
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  options() {
    return Array.from(this.panelTarget.querySelectorAll("[data-category-select-option]"))
      .map((option) => ({
        id: option.dataset.categorySelectId,
        label: option.dataset.categorySelectLabel
      }))
  }
}