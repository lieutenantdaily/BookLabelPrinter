class AddBuybackIdToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :buyback_id, :string
  end
end
