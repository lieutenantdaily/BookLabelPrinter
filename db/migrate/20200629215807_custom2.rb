class Custom2 < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :vendor, :string
  end
end
