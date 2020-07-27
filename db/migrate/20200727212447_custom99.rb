class Custom99 < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :shipper, :string
    add_column :buybacks, :tbm_price, :string
  end
end
