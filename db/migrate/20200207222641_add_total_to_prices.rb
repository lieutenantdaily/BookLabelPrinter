class AddTotalToPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :total, :string
  end
end
