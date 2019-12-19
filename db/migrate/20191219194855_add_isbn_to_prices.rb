class AddIsbnToPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :isbn, :string
    add_column :prices, :inventory_price, :string
    add_column :prices, :sold_price, :string
    add_column :prices, :wolesale_price, :string
    add_column :prices, :difference, :string
  end
end
