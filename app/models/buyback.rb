class Buyback < ApplicationRecord
    # Bulk upload 
    def self.import(file)
        require 'csv'
        Buyback.delete_all
        CSV.foreach(file.path, headers: true) do |row|
            buyback_hash = Buyback.new
            buyback_hash.order_id = row[0]
            buyback_hash.price = row[1]
            buyback_hash.isbn = row[2]
            buyback_hash.condition = row[3]
            buyback_hash.source = row[4]
            buyback_hash.buyback_id = row[5]
            buyback_hash.save
        end
    end
    
    
    def self.search(search)
        where("order_id LIKE ?", "%#{search}%") 
        # if search
        #     order = Buyback.find_by(order_id: search)
        #     if order
        #         self.where(order_id: order)
        #     end
        # end
    end


end
