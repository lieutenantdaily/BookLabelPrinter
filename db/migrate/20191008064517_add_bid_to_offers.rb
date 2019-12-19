class AddBidToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :bid, :string
  end
end
