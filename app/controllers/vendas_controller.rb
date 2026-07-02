class VendasController < ApplicationController
  skip_after_action :verify_authorized, only: %i[new produto_card estudante_card]

  def new
  end

  def create
    authorize :venda, :create?

    cantina = current_user.cantina
    unless cantina
      render json: { erros: [ "Usuário sem cantina associada" ] }, status: :unprocessable_entity
      return
    end

    if params[:estudante_id].present?
      (params[:itens] || []).each do |item|
        produto = Produto.find_by(id: item[:produto_id])
        next unless produto

        if Bloqueio.ativos.para_estudante(params[:estudante_id]).para_produto(produto.id).exists?
          render json: { erros: [ "#{produto.nome} está bloqueado para este estudante" ] },
                 status: :unprocessable_entity
          return
        end
      end
    end

    compra = Compra.new(
      cantina: cantina,
      status: :rascunho,
      valor_total: 0
    )

    if params[:estudante_id].present?
      compra.estudante = Estudante.find_by(id: params[:estudante_id])
    end

    (params[:itens] || []).each do |item|
      compra.itens_lancamento.build(
        produto_id: item[:produto_id],
        quantidade: item[:quantidade],
        valor_unitario: item[:preco],
        sub_total: item[:subtotal]
      )
    end

    compra.valor_total = compra.itens_lancamento.sum { |i| i.sub_total || 0 }
    compra.status = :pago if params[:pagamento].present?

    if (pagamento_params = params[:pagamento]).present?
      forma = FormaPagamento.find_by("nome ILIKE ?", pagamento_params[:forma])
      unless forma
        render json: { erros: [ "Forma de pagamento '#{pagamento_params[:forma]}' não encontrada" ] },
               status: :unprocessable_entity
        return
      end

      compra.pagamentos.build(
        forma_pagamento: forma,
        valor: pagamento_params[:valor_recebido],
        troco: pagamento_params[:troco]
      )
    end

    if compra.save
      render json: compra.as_json(include: [ :itens_lancamento, :pagamentos ]), status: :created
    else
      render json: { erros: compra.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def cancelar
    authorize :venda, :cancel?

    compra = Compra.where(cantina: current_user.cantina).find(params[:id])
    compra.update!(status: :cancelado)
    render json: compra.as_json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { erros: [ "Venda não encontrada" ] }, status: :not_found
  end

  def produto_card
    @produto = Produto.find(params[:id])
    render partial: "vendas/produto_card", layout: false, locals: { produto: @produto }
  end

  def estudante_card
    @estudante = Estudante.includes(reservas: :produto).find(params[:id])
    render partial: "vendas/estudante", layout: false, locals: { estudante: @estudante }
  end
end
