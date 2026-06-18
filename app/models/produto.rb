class Produto < ApplicationRecord
  attr_reader :preco

  belongs_to :categoria, optional: true
  has_many :item_precos
  has_many :bloqueios, dependent: :destroy
  has_many :reservas, dependent: :destroy
  has_many :cardapio_produtos, dependent: :destroy
  has_many :cardapios, through: :cardapio_produtos 

  after_create :criar_preco_base
  after_update :atualizar_preco_base
   
  validates :nome, presence: true, length: { maximum: 100 }
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
  scope :por_nome_categoria, ->(nome_cat) {
    return all if nome_cat.blank?
    joins(:categoria).where("categorias.nome ILIKE ?", "%#{nome_cat.strip}%")
  }

  def preco_atual
    tempo_atual = Time.current

    ItemPreco
      .joins(:tabela_preco)
      .where(
        "tabela_precos.status = ?
         AND (
           (tabela_precos.fimVigencia >= ? AND tabela_precos.inicioVigencia <= ?)
           OR
           (tabela_precos.fimVigencia IS NULL AND tabela_precos.inicioVigencia IS NULL)
         )
         AND item_precos.produto_id = ?",
        1, tempo_atual, tempo_atual, id
      )
      .order(Arel.sql("COALESCE(tabela_precos.fimVigencia - tabela_precos.inicioVigencia, '9999 days'::interval) ASC"))
      .first&.preco
  end

  def preco=(valor)
    @preco = valor
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

  def criar_preco_base
    return unless @preco.present?

    base = TabelaPreco.find_by(tipo: :base, status: :ativo)
    return unless base

    item = ItemPreco.create!(tabela_preco_id: base.id, produto_id: id, preco: @preco)
  end

  def atualizar_preco_base
    return unless @preco.present?

    base = TabelaPreco.find_by(tipo: :base, status: :ativo)
    return unless base

    item = ItemPreco.find_or_initialize_by(tabela_preco_id: base.id, produto_id: id)
    item.update!(preco: @preco)
  end
end