return unless Rails.env.development? || Rails.env.test?

require "faker"

Faker::Config.random = Random.new(20_260_604)

DEFAULT_STUDENTS_COUNT = 50

NOMES_MASC = [
  "Arthur", "Bernardo", "Davi", "Enzo", "Gabriel", "Heitor", "João", "Lucas",
  "Miguel", "Pedro", "Rafael", "Samuel", "Thiago", "Vinicius", "Yuri",
  "Alexandre", "Bruno", "Caio", "Daniel", "Eduardo", "Felipe", "Gustavo",
  "Henrique", "Igor", "Leonardo", "Matheus", "Nicolas", "Otávio", "Paulo",
  "Rodrigo", "Sérgio", "Vitor", "Lucca", "Breno", "Diego", "Erick", "Fabio",
  "Guilherme", "Hugo", "João Pedro", "Kaique", "Luan", "Marcos", "Nathan",
  "Oliver", "Pietro", "Raul", "Ryan", "Theo", "William"
].freeze

NOMES_FEM = [
  "Alice", "Beatriz", "Carla", "Daniela", "Eduarda", "Fernanda", "Gabriela",
  "Helena", "Isabela", "Júlia", "Larissa", "Letícia", "Manuela", "Mariana",
  "Natália", "Patrícia", "Rafaela", "Sofia", "Valentina", "Vitória",
  "Amanda", "Bianca", "Camila", "Débora", "Elisa", "Flávia", "Giovana",
  "Isadora", "Jéssica", "Lorena", "Luiza", "Mirela", "Nicole", "Priscila",
  "Rebeca", "Sabrina", "Tainá", "Vanessa", "Yasmin", "Ana Clara",
  "Ana Luiza", "Bárbara", "Caroline", "Diana", "Emanuelle", "Fabiana",
  "Giovanna", "Isabelly", "Livia", "Melissa"
].freeze

TURMAS = %w[1A 1B 2A 2B 3A 3B].freeze

def seed_students_count
  explicit = ENV["ESTUDANTES_COUNT"].presence || ENV["STUDENTS_COUNT"].presence
  return explicit.to_i if explicit.present? && explicit.to_i.positive?

  return DEFAULT_STUDENTS_COUNT unless $stdin.tty?

  print "Quantos estudantes deseja gerar? [#{DEFAULT_STUDENTS_COUNT}]: "
  input = STDIN.gets&.strip.to_i
  input.positive? ? input : DEFAULT_STUDENTS_COUNT
end

conn = ActiveRecord::Base.connection
previous_schema = conn.schema_search_path

Escola.all.each do |escola|
  conn.schema_search_path = "#{escola.schema_name},public"

  count = seed_students_count

  count.times do |i|
    nomes = NOMES_MASC + NOMES_FEM
    nome = nomes[i % nomes.size]
    sobrenome = Faker::Name.last_name
    nome_completo = "#{nome} #{sobrenome}"

    estudante = Estudante.find_or_initialize_by(nome: nome_completo)
    estudante.assign_attributes(
      matricula: format("MAT-%05d", i + 1),
      turma: TURMAS.sample,
      serie: rand(6..9),
      data_nascimento: Faker::Date.birthday(min_age: 6, max_age: 18),
      nivel_escolaridade: [0, 1].sample
    )
    estudante.save!
  end

  puts "Estudantes carregados para #{escola.nome}: #{count}"
end

conn.schema_search_path = previous_schema
