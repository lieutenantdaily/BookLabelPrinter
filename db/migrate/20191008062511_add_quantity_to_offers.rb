class AddQuantityToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :quantity, :string
    add_column :offers, :minimum, :string
  end
end
