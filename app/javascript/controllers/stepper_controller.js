import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { current : Number };

    connect() {
        if(isNaN(this.currentValue)) {
            this.currentValue = 0;
        }
        this.render();
    }

    next() {
        const total = this.stepElements().length;
        if(this.currentValue < total - 1) {
            this.currentValue++;
            this.render();
        }
    }

    prev() {
        if(this.currentValue > 0) {
            this.currentValue--;
            this.render();
        }
    }

    render() {
        const current = this.currentValue;
        this.stepElements().forEach((el, index) => {
            if (index === current) {
                el.classList.remove("hidden");
            } else {
                el.classList.add("hidden");
            }
        });
        const headerItems = Array.from(this.element.querySelectorAll("ol > li"));
        headerItems.forEach((li, index) => {
            const circle = li.querySelector('span');
            const rubyClasses = ['border-ruby-500','bg-ruby-500','text-white','dark:border-ruby-500','dark:bg-ruby-500'];
            const neutralClasses = ['border-gray-300','bg-white','text-gray-600','dark:border-gray-600','dark:bg-gray-800','dark:text-gray-300'];

            if (circle) {
                if (index === current) {
                    neutralClasses.forEach(c => circle.classList.remove(c));
                    rubyClasses.forEach(c => circle.classList.add(c));
                } else {
                    rubyClasses.forEach(c => circle.classList.remove(c));
                    neutralClasses.forEach(c => circle.classList.add(c));
                }
            }

            const completedLineClass = 'after:border-ruby-500';
            const completedLineDark = 'dark:after:border-ruby-500';
            const pendingLineClass = 'after:border-gray-300';
            const pendingLineDark = 'dark:after:border-gray-600';

            li.classList.remove(completedLineClass, completedLineDark, pendingLineClass, pendingLineDark);
            if (index < current) {
                li.classList.add(completedLineClass, completedLineDark);
            } else if (index < headerItems.length - 1) {
                li.classList.add(pendingLineClass, pendingLineDark);
            }
        });
    }

    stepElements() {
        return Array.from(this.element.querySelectorAll("[data-step-index]"));
    }
}