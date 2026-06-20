import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    const collapsed = localStorage.getItem("sidebar_collapsed") === "true"
    if (collapsed) {
      this.sidebarTarget.classList.add("w-16", "sidebar-collapsed")
      this.sidebarTarget.classList.remove("w-64")
    }
  }

  toggle() {
    const collapsed = this.sidebarTarget.classList.contains("sidebar-collapsed")
    if (collapsed) {
      this.sidebarTarget.classList.remove("w-16", "sidebar-collapsed")
      this.sidebarTarget.classList.add("w-64")
      localStorage.setItem("sidebar_collapsed", "false")
    } else {
      this.sidebarTarget.classList.remove("w-64")
      this.sidebarTarget.classList.add("w-16", "sidebar-collapsed")
      localStorage.setItem("sidebar_collapsed", "true")
    }
  }
}
