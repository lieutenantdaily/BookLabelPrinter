class AddMinQtyToCompareFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :compare_files, :isbn, :string
    add_column :compare_files, :inventory_price, :string
    add_column :compare_files, :sold_price, :string
    add_column :compare_files, :wolesale_price, :string
    add_column :compare_files, :difference, :string
  end
end
