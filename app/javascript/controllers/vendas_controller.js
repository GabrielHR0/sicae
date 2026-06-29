import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selecaoProduto", "selecaoEstudante", "carrinhoItens", "placeholder", "subtotal", "botaoFinalizar"]

  connect() {
    this.itens = []
    this.abortController = null
  }

  selecionaProduto(event) {
    if (!event.detail.codigo) return

    this.produtoAtual = event.detail

    if (this.abortController) this.abortController.abort()
    this.abortController = new AbortController()

    fetch(`/vendas/produtos/${this.produtoAtual.id}/card`, { signal: this.abortController.signal })
      .then(r => r.text())
      .then(html => {
        this.selecaoProdutoTarget.innerHTML = html
      })
      .catch(err => {
        if (err.name === "AbortError") return
        console.error(err)
      })
  }

  selecionaEstudante(event) {
    if (!event.detail.matricula) return

    this.estudanteAtual = event.detail

    if (this.abortController) this.abortController.abort()
    this.abortController = new AbortController()

    fetch(`/vendas/estudantes/${this.estudanteAtual.id}/card`, { signal: this.abortController.signal })
      .then(r => r.text())
      .then(html => {
        this.selecaoEstudanteTarget.innerHTML = html
      })
      .catch(err => {
        if (err.name === "AbortError") return
        console.error(err)
      })
  }

  limparEstudante() {
    this.estudanteAtual = null
    this.selecaoEstudanteTarget.innerHTML = ""
  }

  adicionarReserva(event) {
    const btn = event.currentTarget
    const item = {
      produto_id: parseInt(btn.dataset.produtoId),
      nome: btn.dataset.produtoNome,
      preco: parseFloat(btn.dataset.produtoPreco),
      codigo: btn.dataset.produtoCodigo,
      quantidade: 1,
      subtotal: parseFloat(btn.dataset.produtoPreco)
    }

    const existente = this.itens.find(i => i.produto_id === item.produto_id)
    if (existente) {
      existente.quantidade += 1
      existente.subtotal = existente.preco * existente.quantidade
    } else {
      this.itens.push(item)
    }

    this.renderizarCarrinho()
    this.mostrarNotificacao(`${item.nome} adicionado ao carrinho`)
  }

  pagarReserva(event) {
    const btn = event.currentTarget
    this.itens = [{
      produto_id: parseInt(btn.dataset.produtoId),
      nome: btn.dataset.produtoNome,
      preco: parseFloat(btn.dataset.produtoPreco),
      codigo: btn.dataset.produtoCodigo,
      quantidade: 1,
      subtotal: parseFloat(btn.dataset.produtoPreco)
    }]

    this.renderizarCarrinho()
    this.abrirModalPagamento()
  }

  incrementarQtd(event) {
    const input = event.currentTarget.parentElement.querySelector('input[type="number"]')
    input.value = parseInt(input.value) + 1
    this.atualizarSubtotalCard(event)
  }

  decrementarQtd(event) {
    const input = event.currentTarget.parentElement.querySelector('input[type="number"]')
    const val = parseInt(input.value)
    if (val > 1) {
      input.value = val - 1
    }
    this.atualizarSubtotalCard(event)
  }

  atualizarSubtotalCard(event) {
    const card = event.currentTarget.closest('[data-vendas-target="selecaoProduto"]')
    const input = card.querySelector('input[type="number"]')
    const quantidade = parseInt(input.value) || 1
    const span = card.querySelector('#subtotal-item')
    if (span) {
      const total = this.produtoAtual.preco * quantidade
      span.textContent = total.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
    }
  }

  adicionaAoCarrinho(event) {
    const card = event.currentTarget.closest('[data-vendas-target="selecaoProduto"]')
    const input = card.querySelector('input[type="number"]')
    const quantidade = parseInt(input.value) || 1

    const item = {
      produto_id: this.produtoAtual.id,
      nome: this.produtoAtual.nome,
      preco: this.produtoAtual.preco,
      codigo: this.produtoAtual.codigo,
      quantidade: quantidade,
      subtotal: this.produtoAtual.preco * quantidade
    }

    const existente = this.itens.find(i => i.produto_id === item.produto_id)
    if (existente) {
      existente.quantidade += quantidade
      existente.subtotal = existente.preco * existente.quantidade
    } else {
      this.itens.push(item)
    }

    this.renderizarCarrinho()
    this.cancelaSelecao()
  }

  cancelaSelecao() {
    this.selecaoProdutoTarget.innerHTML = ""
  }

  renderizarCarrinho() {
    if (this.itens.length === 0) {
      this.placeholderTarget.classList.remove("hidden")
      this.carrinhoItensTarget.innerHTML = ""
      this.subtotalTarget.textContent = "R$ 0,00"
      return
    }

    this.placeholderTarget.classList.add("hidden")

    this.carrinhoItensTarget.innerHTML = this.itens.map(item => `
      <div class="flex items-center gap-1 text-xs">
        <span class="text-gray-700 dark:text-gray-200 font-medium truncate">${item.codigo} - ${item.nome}</span>
        <span class="text-gray-500 dark:text-gray-400 shrink-0 ml-1">${item.quantidade}x</span>
        <span class="tabular-nums text-gray-900 dark:text-white font-semibold shrink-0">
          ${Number(item.preco).toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}
        </span>
        <span class="flex-1 border-b border-dotted border-gray-300 dark:border-gray-600"></span>
        <span class="tabular-nums text-gray-900 dark:text-white font-semibold shrink-0">
          ${Number(item.subtotal).toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}
        </span>
      </div>
    `).join("")

    const total = this.itens.reduce((acc, item) => acc + item.subtotal, 0)
    this.subtotalTarget.textContent = total.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
  }

  abrirModalPagamento() {
    if (this.itens.length === 0) return

    const modal = document.getElementById("modal-pagamento")
    if (!modal) return

    const total = this.itens.reduce((acc, item) => acc + item.subtotal, 0)
    const controller = this.application.getControllerForElementAndIdentifier(modal, "pagamento-stepper")
    if (controller) {
      controller.abrir({ detail: { total } })
    }
  }

  confirmarPagamento(event) {
    const pagamento = event.detail

    const botao = this.botaoFinalizarTarget
    if (botao) {
      botao.disabled = true
      botao.textContent = "Enviando..."
    }

    const body = {
      itens: this.itens.map(i => ({
        produto_id: i.produto_id,
        quantidade: i.quantidade,
        preco: i.preco,
        subtotal: i.subtotal
      })),
      pagamento: {
        forma: pagamento.forma,
        valor_recebido: pagamento.valor_recebido,
        troco: pagamento.troco
      }
    }

    if (this.estudanteAtual) {
      body.estudante_id = this.estudanteAtual.id
    }

    const csrfToken = document.querySelector("[name='csrf-token']")?.content

    fetch("/vendas", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify(body)
    })
      .then(async r => {
        if (!r.ok) {
          const err = await r.json().catch(() => ({}))
          throw new Error(err.erros?.join(", ") || "Erro ao finalizar venda")
        }
        return r.json()
      })
      .then(data => {
        this.ultimaVenda = data
        this.selecaoProdutoTarget.innerHTML = ""
        this.selecaoEstudanteTarget.innerHTML = ""
        this.mostrarNotificacao("Venda finalizada com sucesso!")
        this.itens = []
        this.estudanteAtual = null
        this.renderizarCarrinho()
      })
      .catch(err => {
        this.mostrarNotificacao(err.message)
      })
      .finally(() => {
        if (botao) {
          botao.disabled = false
          botao.textContent = "Finalizar Venda"
        }
      })
  }

  recusarPagamento() {
    this.selecaoProdutoTarget.innerHTML = ""
    this.selecaoEstudanteTarget.innerHTML = ""
    this.itens = []
    this.estudanteAtual = null
    this.renderizarCarrinho()
  }

  mostrarNotificacao(texto) {
    const div = document.createElement("div")
    div.className = "fixed top-4 right-4 z-[100] rounded-xl bg-emerald-600 px-5 py-3 text-sm font-semibold text-white shadow-lg animate-slide-in"
    div.textContent = texto
    document.body.appendChild(div)
    setTimeout(() => {
      div.style.opacity = "0"
      div.style.transition = "opacity 0.3s"
      setTimeout(() => div.remove(), 300)
    }, 3000)
  }
}
