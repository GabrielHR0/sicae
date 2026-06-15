import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "themeLabel"]

  connect() {
    this.applyTheme(this.isDark())
    this.initHeaderState()
    this.initAccordion()
    this.initTabs()
    this.initModals()
    this.initReveal()
    this.initCounters()
    this.initSwiper()
    this.initYearStamp()
    this.initDemoForms()
  }

  isDark() {
    return document.documentElement.classList.contains("dark")
  }

  applyTheme(theme) {
    document.documentElement.classList.toggle("dark", theme)
    document.documentElement.dataset.theme = theme ? "dark" : "light"
    window.localStorage.setItem("theme", theme ? "dark" : "light")
    const labels = document.querySelectorAll("[data-theme-label]")
    labels.forEach(el => { el.textContent = theme ? "Dark" : "Light" })
  }

  toggleTheme() {
    this.applyTheme(!this.isDark())
  }

  toggleMobile(event) {
    const btn = event.currentTarget
    const expanded = btn.getAttribute("aria-expanded") === "true"
    btn.setAttribute("aria-expanded", expanded ? "false" : "true")
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("hidden", expanded)
    }
  }

  initHeaderState() {
    const header = document.querySelector("[data-site-header]")
    if (!header) return
    const sync = () => header.classList.toggle("scrolled", window.scrollY > 12)
    sync()
    window.addEventListener("scroll", sync, { passive: true })
  }

  initAccordion() {
    document.querySelectorAll("[data-accordion-item]").forEach((item, i) => {
      const btn = item.querySelector("[data-accordion-trigger]")
      const panel = item.querySelector("[data-accordion-panel]")
      if (!btn || !panel) return

      const open = () => {
        item.classList.add("is-open")
        btn.setAttribute("aria-expanded", "true")
        panel.style.maxHeight = panel.scrollHeight + "px"
      }
      const close = () => {
        item.classList.remove("is-open")
        btn.setAttribute("aria-expanded", "false")
        panel.style.maxHeight = "0px"
      }

      if (i === 0 || item.dataset.open === "true") open()
      else close()

      btn.addEventListener("click", () => {
        const isOpen = item.classList.contains("is-open")
        item.parentElement?.querySelectorAll("[data-accordion-item]").forEach(sibling => {
          if (sibling !== item) {
            const sb = sibling.querySelector("[data-accordion-trigger]")
            const sp = sibling.querySelector("[data-accordion-panel]")
            sibling.classList.remove("is-open")
            if (sb) sb.setAttribute("aria-expanded", "false")
            if (sp) sp.style.maxHeight = "0px"
          }
        })
        isOpen ? close() : open()
      })
    })
  }

  initTabs() {
    document.querySelectorAll("[data-tab-group]").forEach(group => {
      const buttons = group.querySelectorAll("[data-tab-target]")
      const panels = group.querySelectorAll("[data-tab-panel]")
      if (!buttons.length || !panels.length) return

      const activate = (target) => {
        buttons.forEach(b => {
          b.classList.toggle("is-active", b.dataset.tabTarget === target)
          b.setAttribute("aria-selected", b.dataset.tabTarget === target ? "true" : "false")
        })
        panels.forEach(p => p.classList.toggle("is-active", p.dataset.tabPanel === target))
      }

      buttons.forEach((b, i) => {
        if (i === 0) activate(b.dataset.tabTarget)
        b.addEventListener("click", () => activate(b.dataset.tabTarget))
      })
    })
  }

  initModals() {
    document.querySelectorAll("[data-modal-open]").forEach(btn => {
      btn.addEventListener("click", () => {
        const modal = document.getElementById(btn.getAttribute("data-modal-open"))
        if (!modal) return
        modal.classList.add("is-open")
        document.body.classList.add("overflow-hidden")
      })
    })

    document.querySelectorAll("[data-modal-close]").forEach(btn => {
      btn.addEventListener("click", () => {
        const modal = btn.closest("[data-modal]")
        if (!modal) return
        modal.classList.remove("is-open")
        document.body.classList.remove("overflow-hidden")
      })
    })

    document.querySelectorAll("[data-modal]").forEach(modal => {
      modal.addEventListener("click", e => {
        if (e.target === modal) {
          modal.classList.remove("is-open")
          document.body.classList.remove("overflow-hidden")
        }
      })
    })
  }

  initReveal() {
    const nodes = document.querySelectorAll("[data-reveal]")
    if (!nodes.length) return

    if (!("IntersectionObserver" in window)) {
      nodes.forEach(n => n.classList.add("is-visible"))
      return
    }

    const observer = new IntersectionObserver(
      entries => entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.classList.add("is-visible")
          observer.unobserve(e.target)
        }
      }),
      { threshold: 0.12 }
    )
    nodes.forEach(n => observer.observe(n))
  }

  initCounters() {
    const counters = document.querySelectorAll("[data-counter]")
    if (!counters.length || !("IntersectionObserver" in window)) return

    const animate = (node) => {
      const target = Number(node.dataset.counter || 0)
      const suffix = node.dataset.suffix || ""
      const prefix = node.dataset.prefix || ""
      const duration = Number(node.dataset.duration || 1400)
      const start = performance.now()

      const frame = (now) => {
        const progress = Math.min((now - start) / duration, 1)
        const eased = 1 - Math.pow(1 - progress, 3)
        node.textContent = `${prefix}${Math.round(target * eased).toLocaleString()}${suffix}`
        if (progress < 1) requestAnimationFrame(frame)
      }
      requestAnimationFrame(frame)
    }

    const observer = new IntersectionObserver(
      entries => entries.forEach(e => {
        if (e.isIntersecting) {
          animate(e.target)
          observer.unobserve(e.target)
        }
      }),
      { threshold: 0.6 }
    )
    counters.forEach(c => observer.observe(c))
  }

  initSwiper() {
    if (typeof Swiper === "undefined") return
    const slider = document.querySelector(".testimonials-swiper")
    if (!slider) return

    new Swiper(slider, {
      slidesPerView: 1.08,
      spaceBetween: 18,
      pagination: { el: ".swiper-pagination", clickable: true },
      breakpoints: {
        768: { slidesPerView: 2, spaceBetween: 22 },
        1200: { slidesPerView: 3, spaceBetween: 24 },
      },
    })
  }

  initYearStamp() {
    document.querySelectorAll("[data-current-year]").forEach(n => {
      n.textContent = new Date().getFullYear()
    })
  }

  initDemoForms() {
    document.querySelectorAll("[data-demo-form]").forEach(form => {
      form.addEventListener("submit", (event) => {
        event.preventDefault()
        const msg = form.querySelector("[data-form-message]")
        if (msg) {
          msg.textContent = "Obrigado! Em breve enviaremos novidades."
          msg.classList.remove("hidden")
        }
      })
    })
  }
}
