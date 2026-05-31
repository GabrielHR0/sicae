import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "submitLabel", "submitSpinner"]

  connect() {
    this.submitting = false
  }

  start() {
    if (this.submitting) return

    this.submitting = true
    this.setBusyState(true)
  }

  end(event) {
    const { success } = event.detail

    if (success) {
      this.closeModal()
      window.location.reload()
      return
    }

    this.submitting = false
    this.setBusyState(false)
  }

  setBusyState(isBusy) {
    this.element.setAttribute("aria-busy", isBusy ? "true" : "false")

    this.element.querySelectorAll("button, input, select, textarea").forEach((field) => {
      if (field.type === "hidden") return
      field.disabled = isBusy
    })

    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.classList.toggle("opacity-70", isBusy)
      this.submitButtonTarget.classList.toggle("cursor-not-allowed", isBusy)
    }

    if (this.hasSubmitLabelTarget) {
      this.submitLabelTarget.classList.toggle("invisible", isBusy)
    }

    if (this.hasSubmitSpinnerTarget) {
      this.submitSpinnerTarget.classList.toggle("hidden", !isBusy)
    }
  }

  closeModal() {
    const modal = this.element.closest("[data-modal-loader-modal-container='true']")

    if (modal) {
      modal.classList.add("hidden")
      modal.setAttribute("aria-hidden", "true")
      modal.style.zIndex = ""
    }

    document.body.classList.remove("overflow-hidden")
  }
}