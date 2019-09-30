class Buyback < ApplicationRecord
    # Bulk upload 
    def self.import(file, destination, initials)
        require 'csv'
        # filename = File.expand_path(CSV.to_s)
        name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        d = destination.gsub("Nebraska", "NEB")
        d = d.gsub("Amazon", "AMZ")
        d = d.gsub("Other", "OTH")
        i = initials
        # Buyback.delete_all
        CSV.foreach(file.path, headers: true) do |row|
            buyback_hash = Buyback.new
            buyback_hash.order_id = name
            buyback_hash.source = "VAL-" + d
            buyback_hash.status = "Review"
            buyback_hash.updated_by = i
            buyback_hash.o_created_at = row[0]
            buyback_hash.buyback_id = row[1]
            buyback_hash.isbn = row[2]
            buyback_hash.title = row[3]
            buyback_hash.title = buyback_hash.title.titleize if buyback_hash.title == buyback_hash.title.upcase
            buyback_hash.price = row[5]
            # buyback_hash.price = buyback_hash.price
            buyback_hash.tracking_number = row[6]
         
            
            duplicate_check = Buyback.find_by(buyback_id: row[1])
            if duplicate_check.blank?
                buyback_hash.save 
            end
        end
    end

    
    
    
    
    def self.search(search)
        # where"order_id LIKE ? OR tracking_number LIKE ?", "%#{search}%", "%#{search}%" 
        where(order_id: search).or(where(tracking_number: search)).or(where(buyback_id: search))
        # if search
        #     order = Buyback.find_by(order_id: search)
        #     if order
        #         self.where(order_id: order)
        #     end
        # end
    end

    def self.to_csv(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(o_created_at buyback_id isbn title author price tracking_number)
            csv << ['ORDER DATE', 'ITEM ID', 'ISBN', 'TITLE', 'AUTHOR', 'PRICE', 'BOX ID']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end

    def self.to_csv2(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(o_created_at buyback_id isbn title price tracking_number status notes)
            csv << ['ORDER DATE', 'ITEM ID', 'ISBN', 'TITLE', 'PRICE', 'BOX ID', 'STATUS', 'NOTES']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end

    def self.to_csv3(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(o_created_at buyback_id isbn title price tracking_number status notes)
            csv << ['ORDER DATE', 'ITEM ID', 'ISBN', 'TITLE', 'PRICE', 'BOX ID', 'STATUS', 'NOTES']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end

    def titleize(str)
        str.capitalize!  # capitalize the first word in case it is part of the no words array
        words_no_cap = ["and", "or", "the", "over", "to", "the", "a", "but"]
        phrase = str.split(" ").map {|word| 
            if words_no_cap.include?(word) 
                word
            else
                word.capitalize
            end
        }.join(" ") # I replaced the "end" in "end.join(" ") with "}" because it wasn't working in Ruby 2.1.1
      phrase  # returns the phrase with all the excluded words
    end



    


end
