import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const defaultOpts = { dateFormat: 'Y-m-d', allowInput: true };
    const dataOpts = this.data.get('options') ? JSON.parse(this.data.get('options')) : {};
    const opts = Object.assign({}, defaultOpts, dataOpts);

    if (!window.flatpickr) {
      console.warn('flatpickr not found on window. Make sure flatpickr script is loaded.');
      return;
    }

    // Ensure theme sync when opening/ready
    const sync = (instance) => {
      if (!instance || !instance.calendarContainer) return;
      const isDark = document.documentElement.classList.contains('dark');
      instance.calendarContainer.classList.toggle('dark', isDark);
      instance.calendarContainer.classList.toggle('light', !isDark);
    };

    // wrap or add callbacks
    const existingOnReady = opts.onReady;
    const existingOnOpen = opts.onOpen;
    opts.onReady = function(selectedDates, dateStr, instance) {
      sync(instance);
      if (typeof existingOnReady === 'function') existingOnReady(selectedDates, dateStr, instance);
    };
    opts.onOpen = function(selectedDates, dateStr, instance) {
      sync(instance);
      if (typeof existingOnOpen === 'function') existingOnOpen(selectedDates, dateStr, instance);
    };

    this.fp = window.flatpickr(this.element, opts);

    // Observe dark class changes on document root and sync calendar theme
    this._observer = new MutationObserver(() => sync(this.fp));
    this._observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
  }

  disconnect() {
    if (this.fp) this.fp.destroy();
    if (this._observer) this._observer.disconnect();
  }
}
