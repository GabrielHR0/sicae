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
            const circle = li.querySelector('.stepper-circle');
            const activeClass = 'stepper-circle-active';
            const neutralClasses = ['border-gray-300','bg-white','text-gray-600','dark:border-gray-600','dark:bg-gray-800','dark:text-gray-300'];

            if (circle) {
                if (index === current) {
                    neutralClasses.forEach(c => circle.classList.remove(c));
                    circle.classList.add(activeClass);
                } else {
                    circle.classList.remove(activeClass);
                    neutralClasses.forEach(c => circle.classList.add(c));
                }
            }

            const completedLineClass = 'stepper-line-completed';
            const pendingLineClass = 'after:border-gray-300';
            const pendingLineDark = 'dark:after:border-gray-600';

            li.classList.remove(completedLineClass, pendingLineClass, pendingLineDark);
            if (index < current) {
                li.classList.add(completedLineClass);
            } else if (index < headerItems.length - 1) {
                li.classList.add(pendingLineClass, pendingLineDark);
            }
        });
    }

    stepElements() {
        return Array.from(this.element.querySelectorAll("[data-step-index]"));
    }
}
