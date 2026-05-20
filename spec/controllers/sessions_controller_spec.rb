require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  render_views

  let!(:user) { create(:user) }

  describe "GET #login" do
    it "renders login page" do
      get :login

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("MarketFlow")
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "creates session and redirects to dashboard" do
        post :create, params: { name: user.name, password: "Senha@123" }

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(home_path)
      end
    end

    context "with invalid credentials" do
      it "re-renders login with unprocessable status" do
        post :create, params: { name: user.name, password: "SenhaErrada@123" }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("Nome ou senha inválidos.")
        expect(response.body).to include("Nome ou senha inválidos.")
        expect(response.body).to include("MarketFlow")
      end

      it "shows validation error when name is blank" do
        post :create, params: { name: "   ", password: "Senha@123" }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("Nome é obrigatório")
      end

      it "handles user not found with error message" do
        post :create, params: { name: "usuario_inexistente", password: "Senha@123" }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("Nome ou senha inválidos.")
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs out and redirects to login" do
      session[:user_id] = user.id

      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
    end
  end
end
