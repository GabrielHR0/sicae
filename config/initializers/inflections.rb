# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

# colocar inflections para palavras em português
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural(/$/, "s")
  inflect.plural(/(s|z|x|ch|sh|ss|o)$/, "\\1es")
  inflect.plural(/(al|el|ol|ul)$/, "\\1is")
  inflect.plural(/(r|n)$/, "\\1es")
  inflect.plural(/ão$/, "ões")

  inflect.singular(/s$/, "")
  inflect.singular(/(s|z|x|ch|sh|ss|o)es$/, "\\1")
  inflect.singular(/(al|el|ol|ul)is$/, "\\1")
  inflect.singular(/(r|n)es$/, "\\1")
  inflect.singular(/ões$/, "ão")

  inflect.irregular "perfil", "perfis"
end
