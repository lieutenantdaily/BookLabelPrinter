class FixColumnName3 < ActiveRecord::Migration[6.0]
  def change
    rename_column :prices, :wholesale_price, :rank
  end
end
