class CreateActivityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_logs do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.string :action, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :activity_logs, :created_at
  end
end
