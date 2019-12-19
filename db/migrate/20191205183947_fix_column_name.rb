class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :compare_files, :wolesale_price, :wholesale_price
  end
end
