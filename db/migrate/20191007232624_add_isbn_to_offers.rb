class AddIsbnToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :isbn, :string
    add_column :offers, :tbm_amount, :string
    add_column :offers, :rank, :string
    add_column :offers, :suggested_bid, :string
  end
end
