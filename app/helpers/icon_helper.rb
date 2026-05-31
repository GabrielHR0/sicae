module IconHelper
  def icon_svg(name, classes: "h-6 w-6", **attrs)
    render partial: "shared/icons/#{name}", formats: [:svg], locals: { classes: classes, attrs: attrs }
  rescue ActionView::MissingTemplate
    attrs_str = attrs.map { |k, v| "#{k}=\"#{ERB::Util.html_escape(v)}\"" }.join(' ')
    "<svg class=\"#{ERB::Util.html_escape(classes)}\" #{attrs_str} viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\">" \
      "<rect width=\"24\" height=\"24\" fill=\"#e5e7eb\"/>" \
      "</svg>".html_safe
  end
end
