class Buyback < ApplicationRecord
    # Bulk upload 
    def self.import(file)
        require 'csv'
        # Buyback.delete_all
        CSV.foreach(file.path, headers: true) do |row|
            buyback_hash = Buyback.new
            buyback_hash.order_id = row[0]
            buyback_hash.price = row[1]
            buyback_hash.isbn = row[2]
            buyback_hash.condition = row[3]
            buyback_hash.source = row[4]
            buyback_hash.buyback_id = row[5]
            buyback_hash.tracking_number = row[6]
            buyback_hash.order_hash = row[7]
            buyback_hash.title = row[8]
            buyback_hash.restricted = row[9]
            buyback_hash.o_created_at = row[10]
            duplicate_check = Buyback.find_by(buyback_id: row[5])
            buyback_hash.save if duplicate_check.blank?
        end
    end

    
    
    
    
    def self.search(search)
        # where"order_id LIKE ? OR tracking_number LIKE ?", "%#{search}%", "%#{search}%" 
        where(order_id: search).or(where(tracking_number: search))
        # if search
        #     order = Buyback.find_by(order_id: search)
        #     if order
        #         self.where(order_id: order)
        #     end
        # end
    end


end
