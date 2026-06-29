import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    if (this.element.hidden) return
    setTimeout(() => this.close(), this.delayValue)
  }

  close() {
    this.element.remove()
  }
}