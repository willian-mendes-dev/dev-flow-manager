require "rails_helper"

RSpec.describe UsersController, type: :controller do
  render_views

  describe "GET #new" do
    it "returns success and initializes a new user" do
      get :new

      user = controller.instance_variable_get(:@user)
      expect(response).to have_http_status(:ok)
      expect(user).to be_a(User)
      expect(user).not_to be_persisted
      expect(response.body).to include("Criar conta - MarketFlow")
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        user: {
          name: "novo_usuario_teste",
          password: "Senha@123",
          password_confirmation: "Senha@123"
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          name: "",
          password: "123",
          password_confirmation: "123"
        }
      }
    end

    it "creates user, auto logs in and redirects with success flash" do
      expect do
        post :create, params: valid_params
      end.to change(User, :count).by(1)

      created_user = User.order(:created_at).last
      expect(session[:user_id]).to eq(created_user.id)
      expect(response).to redirect_to(home_path)
      expect(flash[:notice]).to eq("Conta criada com sucesso.")
    end

    it "does not create user and re-renders new with errors" do
      expect do
        post :create, params: invalid_params
      end.not_to change(User, :count)

      user = controller.instance_variable_get(:@user)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user).to be_a(User)
      expect(user.errors).not_to be_empty
      expect(flash[:alert]).to be_present
      expect(response.body).to include("Criar conta - MarketFlow")
    end
  end
end
