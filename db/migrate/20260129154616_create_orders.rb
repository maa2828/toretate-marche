class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }

      t.integer :status, null: false, default: 0
      t.integer :total_amount, null: false, default: 0

      t.timestamps
    end
  end
end
