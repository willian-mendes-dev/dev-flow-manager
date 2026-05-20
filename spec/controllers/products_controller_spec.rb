require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  let!(:user) do
    User.create!(
      name: "Admin Teste",
      password: "Senha@123",
      password_confirmation: "Senha@123"
    )
  end

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "loads products" do
      product = create(:product, name: "Arroz Especial Teste")

      get :index

      products = controller.instance_variable_get(:@products)
      expect(response).to have_http_status(:ok)
      expect(products).to include(product)
    end

    it "filters by name and category" do
      matched = create(:product, name: "Suco Premium", category: "Bebidas")
      create(:product, name: "Detergente", category: "Limpeza")

      get :index, params: { name: "Suco", category: "Bebidas" }

      products = controller.instance_variable_get(:@products)
      expect(products).to contain_exactly(matched)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        product: {
          name: "Cafe Torrado 500g",
          description: "Cafe premium moido",
          sku: "ALI-CAFE-001",
          price: 19.90,
          stock_quantity: 25,
          category: "Alimentos"
        }
      }
    end

    let(:invalid_params) do
      {
        product: {
          name: "",
          description: "Sem nome",
          sku: "",
          price: -3,
          stock_quantity: 10,
          category: ""
        }
      }
    end

    it "creates a valid product and redirects" do
      expect do
        post :create, params: valid_params
      end.to change(Product, :count).by(1)

      expect(response).to redirect_to(products_path)
    end

    it "continues create flow even when activity log fails" do
      allow(ActivityLog).to receive(:create!).and_raise(StandardError, "erro de log")
      allow(Rails.logger).to receive(:error)

      expect do
        post :create, params: valid_params
      end.to change(Product, :count).by(1)

      expect(response).to redirect_to(products_path)
      expect(Rails.logger).to have_received(:error).with(/Falha ao registrar log de atividade/)
    end

    it "does not create product with invalid data" do
      expect do
        post :create, params: invalid_params
      end.not_to change(Product, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe "GET #new" do
    it "initializes a new product" do
      get :new

      product = controller.instance_variable_get(:@product)
      expect(response).to have_http_status(:ok)
      expect(product).to be_a(Product)
      expect(product).not_to be_persisted
    end
  end

  describe "GET #edit" do
    it "loads product for editing" do
      product = create(:product)

      get :edit, params: { id: product.id }

      expect(response).to have_http_status(:ok)
      expect(controller.instance_variable_get(:@product)).to eq(product)
    end
  end

  describe "PATCH #update" do
    let!(:product) { create(:product, name: "Nome Antigo") }

    it "updates product successfully" do
      patch :update, params: { id: product.id, product: { name: "Nome Novo", stock_quantity: 33 } }

      expect(response).to redirect_to(products_path)
      expect(product.reload.name).to eq("Nome Novo")
      expect(product.stock_quantity).to eq(33)
    end

    it "does not update with invalid data" do
      patch :update, params: { id: product.id, product: { name: "", price: -5 } }

      expect(response).to have_http_status(422)
      expect(product.reload.name).to eq("Nome Antigo")
    end
  end

  describe "DELETE #destroy" do
    it "removes product and redirects" do
      product = create(:product)

      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)

      expect(response).to redirect_to(products_path)
    end
  end
end
