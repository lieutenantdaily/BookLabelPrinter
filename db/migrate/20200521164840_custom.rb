class Custom < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :custom, :string
  end
end
