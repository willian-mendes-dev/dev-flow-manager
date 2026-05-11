class ProductsController < ApplicationController
  before_action :require_login
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_sidebar_view

  def index
    @name_query = params[:name].to_s.strip
    @category_query = params[:category].to_s.strip
    @categories = Product.distinct.order(:category).pluck(:category)
    @products = Product.order(created_at: :desc)

    @products = @products.where("name ILIKE ?", "%#{@name_query}%") if @name_query.present?
    @products = @products.where(category: @category_query) if @category_query.present?
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      log_product_activity(action: "created", product: @product)
      redirect_to products_path, notice: "Produto criado com sucesso."
    else
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      log_product_activity(action: "updated", product: @product)
      redirect_to products_path, notice: "Produto atualizado com sucesso."
    else
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produto removido com sucesso."
  end

  private

  def set_sidebar_view
    @view = "produtos"
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :sku,
      :price,
      :stock_quantity,
      :category
    )
  end

  def log_product_activity(action:, product:)
    description =
      if action == "created"
        "Produto #{product.name} (#{product.sku}) foi criado com estoque inicial de #{product.stock_quantity}."
      else
        changed_fields = product.saved_changes.keys - ["updated_at"]
        changed_label = changed_fields.any? ? changed_fields.join(", ") : "dados gerais"
        "Produto #{product.name} (#{product.sku}) foi atualizado. Campos alterados: #{changed_label}."
      end

    ActivityLog.create!(
      user: current_user,
      product: product,
      action: action,
      description: description
    )
  rescue StandardError => e
    Rails.logger.error("Falha ao registrar log de atividade: #{e.message}")
  end
end
