return unless Rails.env.development? || Rails.env.test?

require "faker"

DEFAULT_RESPONSAVEIS_COUNT = (ENV["RESPONSAVEIS_COUNT"] || 10).to_i
DEFAULT_ESTUDANTES_POR_RESPONSAVEL = (ENV["ESTUDANTES_POR_RESPONSAVEL"] || 2).to_i

Faker::Config.random = Random.new(20_260_530)

responsavel_role = Role.find_by(nome: "responsavel")
abort "Role 'responsavel' não encontrada. Execute db:seed primeiro." unless responsavel_role

escola = Escola.first
abort "Nenhuma escola encontrada. Execute o seed 01_dev primeiro." unless escola

NIVEIS = { fundamental_i: 0, fundamental_ii: 1, medio: 2 }.freeze
SERIES_POR_NIVEL = { 0 => 1..5, 1 => 6..9, 2 => 1..3 }.freeze
TURMAS = %w[A B C].freeze
RELACOES = %w[pai mae tutor outro].freeze

def gerar_cpf
  digits = Array.new(9) { rand(0..9) }
  mod1 = (0..8).sum { |i| digits[i] * (10 - i) } % 11
  dig1 = mod1 < 2 ? 0 : 11 - mod1
  digits << dig1
  mod2 = (0..9).sum { |i| digits[i] * (11 - i) } % 11
  dig2 = mod2 < 2 ? 0 : 11 - mod2
  digits << dig2
  digits.join
end

def gerar_matricula(escola_id, index)
  ano = Date.current.year
  "#{ano}#{format('%03d', escola_id)}#{format('%04d', index + 1)}"
end

count = DEFAULT_RESPONSAVEIS_COUNT
puts "Criando #{count} responsáveis com estudantes..."

criados = 0

count.times do |r_index|
  nome = Faker::Name.name
  username = "resp_#{r_index + 1}_#{escola.id}"
  email = "#{username}@exemplo.com"
  cpf = gerar_cpf

  begin
    ActiveRecord::Base.transaction do
      user = User.create!(
        email: email,
        username: username,
        password: "123456",
        escola: escola
      )

      user.create_perfil!(
        nome: nome,
        cpf: cpf,
        telefone: Faker::PhoneNumber.cell_phone_in_e164.tr("+", "").first(11),
        data_nascimento: Faker::Date.birthday(min_age: 25, max_age: 60)
      )

      user.roles << responsavel_role

      responsavel = Responsavel.create!(
        user: user,
        relacao_parental: RELACOES.sample
      )

      DEFAULT_ESTUDANTES_POR_RESPONSAVEL.times do |e_index|
        nivel = NIVEIS.values.sample
        Estudante.create!(
          nome: Faker::Name.name,
          matricula: gerar_matricula(escola.id, r_index * DEFAULT_ESTUDANTES_POR_RESPONSAVEL + e_index),
          data_nascimento: Faker::Date.birthday(min_age: 6, max_age: 18),
          nivel_escolaridade: nivel,
          serie: rand(SERIES_POR_NIVEL[nivel]),
          turma: TURMAS.sample,
          responsavel: responsavel
        )
      end
    end

    criados += 1
  rescue ActiveRecord::RecordInvalid => e
    puts "  ERRO: #{e.record.errors.full_messages.join(', ')}"
    e.record.errors.details.each { |attr, errs| puts "    #{attr}: #{errs.inspect}" }
  end
end

puts "Concluído: #{criados} responsáveis, #{criados * DEFAULT_ESTUDANTES_POR_RESPONSAVEL} estudantes."
