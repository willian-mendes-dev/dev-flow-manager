class ProductsController < ApplicationController
  before_action :require_login
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_sidebar_view

  def index
    @query = params[:q].to_s.strip
    @products = Product.order(created_at: :desc)
    return if @query.blank?

    @products = @products.where(
      "name ILIKE :q OR sku ILIKE :q OR category ILIKE :q",
      q: "%#{@query}%"
    )
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Produto criado com sucesso."
    else
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
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
end
