class AddTitleToPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :buy_qty, :string
    add_column :prices, :title, :string
    add_column :prices, :vendor_qty, :string
    add_column :prices, :qty_difference, :string
    add_column :prices, :final_qty, :string
  end
end
