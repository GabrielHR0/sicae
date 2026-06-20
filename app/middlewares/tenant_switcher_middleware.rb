class TenantSwitcherMiddleware
  TENANT_FALLBACK = "public".freeze
  EXCLUDED_PATHS = [ "/assets", "/favicon.ico", "/rails", "/up", "/users", "/dashboard" ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    escola_slug = extract_slug(request.path)
    user = request.env["warden"]&.user

    if excluded_path?(request.path)
      return @app.call(env)
    end

    if escola_slug.present?
      tenant = resolve_escola(escola_slug)
      if tenant
        env["SCRIPT_NAME"] ||= ""
        env["SCRIPT_NAME"] += "/#{escola_slug}"
        env["PATH_INFO"] = env["PATH_INFO"].sub("/#{escola_slug}", "")
        return handle_tenant(env, tenant)
      end
    end

    if user&.escola
      tenant = user.escola
      env["SCRIPT_NAME"] ||= ""
      env["SCRIPT_NAME"] += "/#{tenant.slug}"
      return handle_tenant(env, tenant)
    end

    not_found_response(env)
  end

  private

  def handle_tenant(env, tenant)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      Current.escola = tenant
      connection.schema_search_path = "#{tenant.schema_name},#{TENANT_FALLBACK}"

      @app.call(env)
    ensure
      Current.reset
      connection.schema_search_path = TENANT_FALLBACK
    end
  end

  def extract_slug(path)
    slug = path.split("/")[1]
    return nil if slug.blank? || EXCLUDED_PATHS.any? { |excluded| path.start_with?(excluded) }
    slug
  end

  def resolve_escola(slug)
    return nil if slug.blank?
    Rails.cache.fetch("escola_slug:#{slug}", expires_in: 1.hour) do
      Escola.find_by(slug: slug)
    end
  end

  def not_found_response(env)
    env["PATH_INFO"] = "/404"
    @app.call(env)
  end

  def excluded_path?(path)
    EXCLUDED_PATHS.any? { |excluded| path.start_with?(excluded) || path == "/" }
  end
end
