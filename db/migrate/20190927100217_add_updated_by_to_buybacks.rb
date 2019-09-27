class AddUpdatedByToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :updated_by, :string
  end
end
