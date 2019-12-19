class AddMinQtyToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :min_qty, :string
  end
end
