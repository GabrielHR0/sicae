// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'flowbite';

// Enable dismiss behavior for toasts and other Flowbite components
document.addEventListener('click', (event) => {
	try {
		const button = event.target.closest('[data-dismiss-target]');
		if (!button) return;

		const selector = button.getAttribute('data-dismiss-target');
		if (!selector) return;

		const target = document.querySelector(selector);
		if (target) target.remove();
	} catch (err) {
		console.error('Error in dismiss handler', err);
	}
});

// Global error hooks to surface intermittent JS failures
window.addEventListener('error', (e) => {
  console.error('Uncaught error:', e.message || e);
});

window.addEventListener('unhandledrejection', (e) => {
  console.error('Unhandled promise rejection:', e.reason || e);
});
