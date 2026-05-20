require "rails_helper"

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  describe "validations" do
    context "when required fields are missing" do
      it "requires name" do
        product.name = nil

        expect(product).not_to be_valid
        expect(product.errors.of_kind?(:name, :blank)).to be(true)
      end

      it "requires category" do
        product.category = nil

        expect(product).not_to be_valid
        expect(product.errors.of_kind?(:category, :blank)).to be(true)
      end

      it "requires sku" do
        product.sku = nil

        expect(product).not_to be_valid
        expect(product.errors.of_kind?(:sku, :blank)).to be(true)
      end

      it "requires price" do
        product.price = nil

        expect(product).not_to be_valid
        expect(product.errors.of_kind?(:price, :blank)).to be(true)
      end
    end

    context "when price is invalid" do
      it "does not allow negative values" do
        product.price = -1

        expect(product).not_to be_valid
        expect(product.errors.of_kind?(:price, :greater_than_or_equal_to)).to be(true)
      end
    end
  end

  describe ".low_stock" do
    let!(:low_stock_product) do
      create(:product, stock_quantity: 8)
    end

    let!(:out_of_stock_product) do
      create(:product, stock_quantity: 0)
    end

    let!(:healthy_stock_product) do
      create(:product, stock_quantity: 45)
    end

    it "returns only products with stock between 1 and 20" do
      result = described_class.low_stock

      expect(result).to include(low_stock_product)
      expect(result).not_to include(out_of_stock_product)
      expect(result).not_to include(healthy_stock_product)
    end
  end
end
