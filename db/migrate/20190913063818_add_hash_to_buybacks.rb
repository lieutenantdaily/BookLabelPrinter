class AddHashToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :hash, :string
  end
end
