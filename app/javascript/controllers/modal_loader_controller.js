import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    const trigger = event.currentTarget
    const modalId = trigger.dataset.modalLoaderModalId
    if (!modalId) return

    const modal = document.getElementById(modalId)

    if (modal) {
      modal.classList.remove("hidden")
      modal.setAttribute("aria-hidden", "false")
    }

    document.body.classList.add("overflow-hidden")
  }

  close(event) {
    const trigger = event.currentTarget
    const modalId = trigger.dataset.modalHide
    const modal = modalId ? document.getElementById(modalId) : trigger.closest("[id]")

    if (modal) {
      modal.classList.add("hidden")
      modal.setAttribute("aria-hidden", "true")
    }

    document.body.classList.remove("overflow-hidden")
  }
}