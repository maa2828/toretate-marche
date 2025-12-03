class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.integer :price, null: false
      t.integer :stock_quantity, default: 0
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    
    add_index :products, :status
  end
end
