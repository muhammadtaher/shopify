class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :customer_id
      t.string :variant_id
      t.date :ordered_at
      t.string :order_id

      t.timestamps null: false
    end
  end
end
