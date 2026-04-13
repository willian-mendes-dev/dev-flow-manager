class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :sku, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :stock_quantity, null: false, default: 0
      t.string :category, null: false

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :name
    add_index :products, :category
  end
end
