class FixColumnName4 < ActiveRecord::Migration[6.0]
  def change
    rename_column :prices, :inventory_price, :amount
    rename_column :prices, :sold_price, :source
  end
end
