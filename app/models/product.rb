class Product < ApplicationRecord
  validates :name, :sku, :category, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
