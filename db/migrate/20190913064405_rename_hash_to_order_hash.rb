class RenameHashToOrderHash < ActiveRecord::Migration[6.0]
  def change
    rename_column :buybacks, :hash, :order_hash
  end
end
