import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    const trigger = event.currentTarget
    const modalId = trigger.dataset.modalLoaderModalId
    if (!modalId) return

    const modal = document.getElementById(modalId)
    if (!modal) return

    this.resetModalFrame(modal)

    modal.style.zIndex = "60"
    modal.classList.remove("hidden")
    modal.setAttribute("aria-hidden", "false")

    window.setTimeout(() => {
      this.hideAllModals(modal)
    }, 0)

    document.body.classList.add("overflow-hidden")
  }

  close(event) {
    const trigger = event.currentTarget
    const modalId = trigger?.dataset?.modalHide
    const modal = modalId
      ? document.getElementById(modalId)
      : trigger?.closest("[data-modal-loader-modal-container='true']")

    if (modal) {
      modal.classList.add("hidden")
      modal.setAttribute("aria-hidden", "true")
      modal.style.zIndex = ""
      this.resetModalFrame(modal)
    }

    document.body.classList.remove("overflow-hidden")
  }

  backdropClose(event) {
    if (event.target !== event.currentTarget) return
    this.close(event)
  }

  hideAllModals(exceptModal = null) {
    document.querySelectorAll("[data-modal-loader-modal-container='true']").forEach((modal) => {
      if (modal === exceptModal) return
      modal.classList.add("hidden")
      modal.setAttribute("aria-hidden", "true")
      modal.style.zIndex = ""
      this.resetModalFrame(modal)
    })
  }

  resetModalFrame(modal) {
    const frame = modal.querySelector("turbo-frame")
    const loadingTemplate = modal.querySelector("template[data-modal-loader-loading-template]")

    if (frame && loadingTemplate) {
      frame.innerHTML = loadingTemplate.innerHTML
    }
  }
}