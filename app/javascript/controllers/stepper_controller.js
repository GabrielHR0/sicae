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
        // update header icons and connecting lines
        const headerItems = Array.from(this.element.querySelectorAll("ol > li"));
        headerItems.forEach((li, index) => {
            const circle = li.querySelector('span');
            // classes for highlighted (current)
            const indigoClasses = ['border-indigo-600','bg-indigo-600','text-white','dark:border-indigo-500','dark:bg-indigo-500'];
            // classes for neutral (upcoming/completed without highlight)
            const neutralClasses = ['border-gray-300','bg-white','text-gray-600','dark:border-gray-600','dark:bg-gray-800','dark:text-gray-300'];

            if (circle) {
                if (index === current) {
                    neutralClasses.forEach(c => circle.classList.remove(c));
                    indigoClasses.forEach(c => circle.classList.add(c));
                } else {
                    indigoClasses.forEach(c => circle.classList.remove(c));
                    neutralClasses.forEach(c => circle.classList.add(c));
                }
            }

            // update connecting line color via pseudo-class helper classes on the li
            const completedLineClass = 'after:border-indigo-400';
            const completedLineDark = 'dark:after:border-indigo-300';
            const pendingLineClass = 'after:border-gray-300';
            const pendingLineDark = 'dark:after:border-gray-600';

            // remove all four then add appropriate ones
            li.classList.remove(completedLineClass, completedLineDark, pendingLineClass, pendingLineDark);
            if (index < current) {
                li.classList.add(completedLineClass, completedLineDark);
            } else if (index < headerItems.length - 1) {
                // only add pending if not the last item (last has no after element)
                li.classList.add(pendingLineClass, pendingLineDark);
            }
        });
    }

    stepElements() {
        return Array.from(this.element.querySelectorAll("[data-step-index]"));
    }
}