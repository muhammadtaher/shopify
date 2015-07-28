class AddProductColumn < ActiveRecord::Migration
  def change
        add_column :purchases, :product_id, :string
  end
end
