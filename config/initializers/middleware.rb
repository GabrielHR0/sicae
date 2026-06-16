require_dependency "tenant_switcher_middleware"

Rails.application.config.middleware.insert_after(
  Warden::Manager,
  TenantSwitcherMiddleware
)