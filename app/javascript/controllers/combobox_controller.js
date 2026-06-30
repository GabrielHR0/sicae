import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "results"]
    static values = {
        url: String,
        display: { type: String, default: "${nome}" },
        textField: { type: String, default: "nome" }
    }

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
                    this.resultsTarget.innerHTML = dados.map(item => {
                        const html = this.displayValue.replace(
                            /\$\{(\w+)\}/g,
                            (_, field) => item[field] ?? ""
                        )
                        return `<li data-action="click->combobox#select"
                                    data-id="${item.id}"
                                    class="px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer
                                           text-sm flex justify-between items-center transition-colors duration-150"
                                    data-fields='${JSON.stringify(item).replace(/'/g, "'")}'>
                                    ${html}
                                </li>`
                    }).join("")
                    this.resultsTarget.classList.remove("hidden")
                })
        }, 300)
    }

    select(event) {
        const li = event.currentTarget
        const fields = JSON.parse(li.dataset.fields)
        this.inputTarget.value = fields[this.textFieldValue] ?? ""
        this.resultsTarget.classList.add("hidden")
        this.dispatch("selected", { detail: fields })
    }

    limpar() {
        this.inputTarget.value = ""
        this.resultsTarget.classList.add("hidden")
        this.inputTarget.focus()
    }
}
