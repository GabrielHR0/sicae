import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "results"]
    static values = { url: String }

    connect() {
        this.timeout = null
    }

    search() {
        clearTimeout(this.timeout)
        const termo = this.inputTarget.value.trim()

        if (termo.length < 1) {
            this.resultsTarget.classList.add("hidden")
            return
        }

        this.timeout = setTimeout(() => {
            fetch(`${this.urlValue}?q=${encodeURIComponent(termo)}`)
                .then(r => r.json())
                .then(dados => {
                    if (dados.length === 0) {
                        this.resultsTarget.classList.add("hidden")
                        return
                    }
                    this.resultsTarget.innerHTML = dados.map(item =>
                        `<li data-action="click->combobox#select"
                            data-id="${item.id}"
                            class="px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer
                                   text-sm flex justify-between items-center transition-colors duration-150">
                            <span class="text-gray-800 dark:text-gray-200 font-medium">${item.nome}</span>
                            <span class="text-gray-900 dark:text-gray-100 font-semibold tabular-nums">R$ ${item.preco}</span>
                        </li>`
                    ).join("")
                    this.resultsTarget.classList.remove("hidden")
                })
        }, 300)
    }

    select(event) {
        const item = event.currentTarget
        const nome = item.querySelector("span:first-child").textContent
        this.inputTarget.value = nome
        this.resultsTarget.classList.add("hidden")

        this.dispatch("selected", { detail: { id: item.dataset.id, nome } })
    }

    limpar() {
        this.inputTarget.value = ""
        this.resultsTarget.classList.add("hidden")
        this.inputTarget.focus()
    }
}
