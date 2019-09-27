class AddStatusToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :status, :string
    add_column :buybacks, :notes, :string
  end
end
