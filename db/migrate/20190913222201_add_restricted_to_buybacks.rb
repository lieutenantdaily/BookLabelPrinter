class AddRestrictedToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :restricted, :string
  end
end
