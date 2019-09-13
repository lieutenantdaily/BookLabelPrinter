class AddIndexToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_index :buybacks, :buyback_id, unique: true
  end
end
