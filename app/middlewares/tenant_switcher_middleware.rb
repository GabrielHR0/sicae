class TenantSwitcherMiddleware
  TENANT_FALLBACK = "public".freeze
  EXCLUDED_PATHS = ["/assets", "/favicon.ico", "rails", "up"].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    escola_slug = extract_slug(request.path)

    if escola_slug.blank?
      return not_found_response(env) unless excluded_path?(request.path)
      return @app.call(env)
    end

    if escola_slug.present?
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        tenant = resolve_escola(escola_slug)

        connection.schema_search_path = TENANT_FALLBACK
        return not_found_response(env) if tenant.nil?

        user = request.env["warden"].user
        if user && user.escola != tenant
          return not_found_response(env)
        end
        
        Current.escola = tenant
        connection.schema_search_path = "#{tenant.schema_name},#{TENANT_FALLBACK}"
        
        env["PATH_INFO"] = request.path.sub("/#{escola_slug}", "")

        @app.call(env)
      ensure
        Current.reset
        connection.schema_search_path = TENANT_FALLBACK
      end
    else
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        connection.schema_search_path = TENANT_FALLBACK
      end
      @app.call(env)
    end
  end

  private

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
    EXCLUDED_PATHS.any? { |excluded| path.start_with?(excluded) }
  end
end