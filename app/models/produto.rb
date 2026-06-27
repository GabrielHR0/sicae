class Produto < ApplicationRecord
  belongs_to :categoria, optional: true
  has_many :item_precos
  has_many :bloqueios, dependent: :destroy
  has_many :reservas, dependent: :destroy
  has_many :cardapio_produtos, dependent: :destroy
  has_many :cardapios, through: :cardapio_produtos

  attr_writer :preco

  after_create :criar_preco_base
  after_update :atualizar_preco_base

  validates :nome, presence: true, length: { maximum: 100 }
  validates :codigo, uniqueness: true, allow_blank: true
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_validation :gerar_codigo, on: :create

  scope :ativos, -> { where(ativo: true) }
  scope :disponivel, -> { where("estoque > ?", 0) }
  scope :inativos, -> { where(ativo: false) }
  scope :por_nome_categoria, ->(nome_cat) {
    return all if nome_cat.blank?
    joins(:categoria).where("categorias.nome ILIKE ?", "%#{nome_cat.strip}%")
  }

  def preco
    return @preco if instance_variable_defined?(:@preco)

    ItemPreco
      .joins(:tabela_preco)
      .where(tabela_precos: { tipo: :base, status: :ativo })
      .find_by(produto_id: id)
      &.preco
  end

  def disponivel?
    ativo? && estoque > 0
  end

  def self.stats
    connection.select_one(<<~SQL.squish)
      SELECT
        COUNT(*) AS total_count,
        SUM(CASE WHEN ativo = TRUE THEN 1 ELSE 0 END) AS active_count,
        SUM(CASE WHEN estoque = 0 THEN 1 ELSE 0 END) AS out_of_stock_count,
        COUNT(DISTINCT categoria_id) AS categories_count
      FROM #{table_name}
    SQL
  end

  private

  def gerar_codigo
    return if codigo.present?

    max_id = Produto.maximum(:id) || 0
    self.codigo = format('COD-%05d', max_id + 1)
  end

  def criar_preco_base
    return unless @preco.present?

    base = TabelaPreco.find_by(tipo: :base, status: :ativo)
    return unless base

    ItemPreco.create!(tabela_preco_id: base.id, produto_id: id, preco: @preco)
  end

  def atualizar_preco_base
    return unless @preco.present?

    base = TabelaPreco.find_by(tipo: :base, status: :ativo)
    return unless base

    item = ItemPreco.find_or_initialize_by(tabela_preco_id: base.id, produto_id: id)
    item.update!(preco: @preco)
  end
end
