class HomeController < ApplicationController
  before_action :require_login

  def index
    @view = params[:view].presence || "dashboard"
    load_dashboard_data
    load_cached_ai_insight
  end

  def generate_insights
    require Rails.root.join("app/services/gemini_advisor_service")
    insight_text = ::GeminiAdvisorService.new.generate_insight(stock_snapshot_payload)

    if insight_text.present?
      Rails.cache.write(
        ai_insight_cache_key,
        { text: insight_text, generated_at: Time.current },
        expires_in: 6.hours
      )
      redirect_to home_path(view: "dashboard"), notice: "Análise de IA atualizada com sucesso."
    else
      redirect_to home_path(view: "dashboard"), alert: "Não foi possível gerar a análise no momento."
    end
  end

  private

  def load_dashboard_data
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

  def load_cached_ai_insight
    insight_payload = Rails.cache.read(ai_insight_cache_key) || {}
    @ai_insight = insight_payload[:text]
    @ai_insight_generated_at = insight_payload[:generated_at]
  end

  def ai_insight_cache_key
    "dashboard-ai-insight:user:#{current_user.id}"
  end

  def stock_snapshot_payload
    {
      total_inventory_value: Product.sum("price * stock_quantity").to_f,
      low_stock_count: Product.where(stock_quantity: 1..20).count,
      out_of_stock_count: Product.where(stock_quantity: 0).count,
      category_distribution: Product.group(:category).sum("price * stock_quantity")
    }
  end
end
