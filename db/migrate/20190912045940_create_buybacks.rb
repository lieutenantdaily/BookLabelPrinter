class CreateBuybacks < ActiveRecord::Migration[6.0]
  def change
    create_table :buybacks do |t|
      t.string :order_id
      t.string :price
      t.string :isbn
      t.string :condition
      t.string :source


      t.timestamps
    end
  end
end
