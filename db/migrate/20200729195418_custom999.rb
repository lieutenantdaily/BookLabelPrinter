class Custom999 < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :tracking_number2, :string
  end
end
