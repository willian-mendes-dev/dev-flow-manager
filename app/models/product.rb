class Product < ApplicationRecord
  has_many :activity_logs, dependent: :nullify

  scope :low_stock, -> { where(stock_quantity: 1..20) }

  validates :name, :sku, :category, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
