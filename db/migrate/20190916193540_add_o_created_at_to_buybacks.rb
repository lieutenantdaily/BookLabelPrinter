class AddOCreatedAtToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :o_created_at, :string
  end
end
