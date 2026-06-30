import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "stepDot", "stepNumber", "stepCheck", "stepLabel", "stepLine",
                    "totalExibir", "valorRecebido", "trocoExibir"]

  connect() {
    this.stepAtual = 0
    this.formaSelecionada = null
    this.mostrarStep(0)
  }

  abrir(event) {
    const total = event.detail?.total || 0
    this.total = total
    this.stepAtual = 0
    this.formaSelecionada = null

    if (this.hasTotalExibirTarget) {
      this.totalExibirTarget.textContent = total.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
    }

    this.mostrarStep(0)
    this.element.classList.remove("hidden")
    this.element.classList.add("flex")
    document.body.classList.add("overflow-hidden")
  }

  fechar() {
    this.element.classList.add("hidden")
    this.element.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
  }

  selecionarForma(event) {
    this.formaSelecionada = event.currentTarget.dataset.forma
    this.irParaStep(1)
  }

  irParaStep(idx) {
    this.stepAtual = idx
    this.mostrarStep(idx)
  }

  mostrarStep(idx) {
    this.stepTargets.forEach((el, i) => {
      el.classList.toggle("hidden", i !== idx)
    })

    this.stepDotTargets.forEach((el, i) => {
      const number = el.querySelector("[data-pagamento-stepper-target='stepNumber']")
      const check = el.querySelector("[data-pagamento-stepper-target='stepCheck']")

      if (i < idx) {
        el.className = "flex h-7 w-7 items-center justify-center rounded-full text-xs font-bold bg-ruby-600 text-white transition-all duration-300"
        if (number) number.classList.add("hidden")
        if (check) check.classList.remove("hidden")
      } else if (i === idx) {
        el.className = "flex h-7 w-7 items-center justify-center rounded-full text-xs font-bold bg-ruby-600 text-white ring-2 ring-ruby-300 ring-offset-2 dark:ring-offset-gray-900 transition-all duration-300"
        if (number) number.classList.remove("hidden")
        if (check) check.classList.add("hidden")
      } else {
        el.className = "flex h-7 w-7 items-center justify-center rounded-full text-xs font-bold bg-gray-200 text-gray-500 dark:bg-gray-700 dark:text-gray-400 transition-all duration-300"
        if (number) number.classList.remove("hidden")
        if (check) check.classList.add("hidden")
      }
    })

    this.stepLabelTargets.forEach((el, i) => {
      el.classList.toggle("text-ruby-600", i <= idx)
      el.classList.toggle("dark:text-ruby-400", i <= idx)
      el.classList.toggle("text-gray-400", i > idx)
      el.classList.toggle("dark:text-gray-500", i > idx)
    })

    this.stepLineTargets.forEach((el, i) => {
      el.classList.toggle("bg-ruby-400", i < idx)
      el.classList.toggle("dark:bg-ruby-500", i < idx)
      el.classList.toggle("bg-gray-300", i >= idx)
      el.classList.toggle("dark:bg-gray-600", i >= idx)
    })
  }

  parseMoeda(valor) {
    let v = valor.trim()
    if (v.includes(",")) {
      v = v.replace(/\./g, "").replace(",", ".")
    }
    return parseFloat(v) || 0
  }

  calcularTroco() {
    const recebido = this.parseMoeda(this.valorRecebidoTarget.value)
    const troco = recebido - this.total

    if (this.hasTrocoExibirTarget) {
      if (troco >= 0) {
        this.trocoExibirTarget.textContent = troco.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
        this.trocoExibirTarget.className = "text-xl font-bold text-emerald-600 dark:text-emerald-400 tabular-nums"
      } else {
        this.trocoExibirTarget.textContent = `Faltam ${Math.abs(troco).toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}`
        this.trocoExibirTarget.className = "text-xl font-bold text-red-500 dark:text-red-400 tabular-nums"
      }
    }
  }

  voltar() {
    if (this.stepAtual > 0) {
      this.irParaStep(this.stepAtual - 1)
    }
  }

  confirmar() {
    if (this.formaSelecionada !== "dinheiro") return

    const recebido = this.parseMoeda(this.valorRecebidoTarget.value)

    if (recebido < this.total) return

    const troco = recebido - this.total

    const evento = new CustomEvent("pagamento:confirmado", {
      bubbles: true,
      detail: {
        forma: this.formaSelecionada,
        valor_recebido: recebido,
        troco: troco
      }
    })

    this.element.dispatchEvent(evento)
    this.fechar()
  }

  cancelar() {
    const evento = new CustomEvent("pagamento:recusado", {
      bubbles: true
    })
    this.element.dispatchEvent(evento)
    this.fechar()
  }
}
