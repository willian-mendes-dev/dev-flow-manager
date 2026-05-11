class HomeController < ApplicationController
  before_action :require_login

  def index
    @view = params[:view].presence || "dashboard"
    @products = Product.order(created_at: :desc)
    @low_stock_items = Product.where(stock_quantity: 0..20).order(:stock_quantity, :name)
    @total_products = @products.count
    @low_stock_count = @products.where(stock_quantity: 1..20).count
    @out_of_stock_count = @products.where(stock_quantity: 0).count
    @total_inventory_value = Product.sum("price * stock_quantity")
    @chart_data = Product.group(:category).sum("price * stock_quantity")
    @top_products_data = Product
      .select("name, (price * stock_quantity) as total_value")
      .order(Arel.sql("total_value DESC"))
      .limit(5)
      .map { |product| [product.name, product.total_value.to_f] }
    @recent_products = @products.limit(10)
    @recent_activities = ActivityLog.includes(:user, :product).order(created_at: :desc).limit(8)
  end
end
