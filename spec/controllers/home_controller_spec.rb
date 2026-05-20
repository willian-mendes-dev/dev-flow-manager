require "rails_helper"

RSpec.describe HomeController, type: :controller do
  render_views
  let!(:user) { create(:user) }

  describe "GET #index" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get :index

        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is authenticated" do
      before do
        session[:user_id] = user.id
      end

      it "loads dashboard successfully" do
        get :index, params: { view: "dashboard" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Dashboard")
      end
    end
  end

  describe "POST #generate_insights" do
    before do
      session[:user_id] = user.id
    end

    it "stores insight in cache and redirects with success notice" do
      service_double = instance_double(GeminiAdvisorService, generate_insight: "**Aja agora**")
      allow(GeminiAdvisorService).to receive(:new).and_return(service_double)

      post :generate_insights

      expect(response).to redirect_to(home_path(view: "dashboard"))
      expect(flash[:notice]).to eq("Análise de IA atualizada com sucesso.")
      cached_payload = Rails.cache.read("dashboard-ai-insight:user:#{user.id}")
      expect(cached_payload[:text]).to eq("**Aja agora**")
      expect(cached_payload[:generated_at]).to be_present
    end

    it "redirects with alert when insight generation fails" do
      service_double = instance_double(GeminiAdvisorService, generate_insight: nil)
      allow(GeminiAdvisorService).to receive(:new).and_return(service_double)

      post :generate_insights

      expect(response).to redirect_to(home_path(view: "dashboard"))
      expect(flash[:alert]).to eq("Não foi possível gerar a análise no momento.")
    end
  end
end
