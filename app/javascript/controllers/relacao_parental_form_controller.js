import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["outroField"]

  toggle(event) {
    this.outroFieldTarget.classList.toggle("hidden", event.target.value !== "outro")
  }
}
