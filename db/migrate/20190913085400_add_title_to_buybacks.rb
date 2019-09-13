class AddTitleToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :title, :string
  end
end
