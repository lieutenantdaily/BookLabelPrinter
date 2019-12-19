class FixColumnName2 < ActiveRecord::Migration[6.0]
  def change
    rename_column :prices, :wolesale_price, :wholesale_price
  end
end
