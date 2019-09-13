class AddTrackingNumberToBuybacks < ActiveRecord::Migration[6.0]
  def change
    add_column :buybacks, :tracking_number, :string
  end
end
