import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selecaoProduto", "carrinhoItens", "placeholder", "subtotal"]

  connect() {
    this.itens = []
  }

  selecionaProduto(event) {
    this.produtoAtual = event.detail

    fetch(`/vendas/produtos/${this.produtoAtual.id}/card`)
      .then(r => r.text())
      .then(html => {
        this.selecaoProdutoTarget.innerHTML = html
      })
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
}
