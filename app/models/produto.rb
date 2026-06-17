class Produto < ApplicationRecord
  belongs_to :categoria, optional: true
  has_many :item_precos

  validates :nome, presence: true, length: { maximum: 100 }
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
  scope :por_nome_categoria, ->(nome_cat) {
    return all if nome_cat.blank?
    joins(:categoria).where("categorias.nome ILIKE ?", "%#{nome_cat.strip}%")
  }

  def preco
    tempo_atual = Time.current
    ItemPreco.joins(:tabela_preco)
    .where(
      "
        tabela_precos.status = ?
        AND
        tabela_precos.fimVigencia >= ?
        AND
        tabela_precos.inicioVigencia <= ?
        AND item_precos.produto_id = ?
      ", 0, tempo_atual, tempo_atual, id
    ).first&.preco
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
end
