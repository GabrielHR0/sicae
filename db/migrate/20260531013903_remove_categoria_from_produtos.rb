class RemoveCategoriaFromProdutos < ActiveRecord::Migration[8.1]
  def up
    Produto.reset_column_information

    Produto.find_each do |produto|
      if produto.categoria.present?
        categoria = Categoria.find_or_create_by!(
          nome: produto[:categoria].strip
        )

        produto.update_column(:categoria_id, categoria.id)
      end
    end

    remove_column :produtos, :categoria
  end

  def def down 
    add_column :produtos, :categoria, :string

    Produto.reset_column_information

    Produto.find_each do |produto|
      if produto.categoria_id.present?
        categoria = Categoria.find_by(id: produto.categoria_id)
        produto.update_column(:categoria, categoria.nome) if categoria
      end
    end
  end
end
