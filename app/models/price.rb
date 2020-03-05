class Price < ApplicationRecord
    # Bulk upload 
    def self.import_url()
        require 'csv'
        require 'open-uri'
        csv_path = open('http://metabase.textbookmaniac.com/public/question/2c21d7d9-4d91-484d-b901-ed33f369c720.csv', :read_timeout => 300)
        # name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        Price.delete_all
        ActiveRecord::Base.transaction do
            CSV.foreach(csv_path, headers: true) do |row|
                price_hash = Price.new
                price_hash.isbn = row[0]
                price_ship = row[1]
                price_hash.amount = price_ship.to_f + 2.50
                price_hash.source = row[2]
                price_hash.rank = row[3]

                rank = price_hash.rank.to_f
                
                if rank >= 1000000
                    qty = 0
                end

                if rank < 1000000 && rank >= 700000
                    qty = 1
                end
                
                if rank < 700000 && rank >= 600000
                    qty = 2
                end
                
                if rank < 600000 && rank >= 500000
                    qty = 3
                end
                
                if rank < 500000 && rank >= 400000
                    qty = 4
                end
                
                if rank < 400000 && rank >= 300000
                    qty = 5
                end
                
                if rank < 300000 && rank >= 200000
                    qty = 6
                end

                if rank < 200000 && rank >= 150000
                    qty = 7
                end

                if rank < 150000 && rank >= 100000
                    qty = 8
                end

                if rank < 100000 && rank >= 50000
                    qty = 9
                end

                if rank < 50000
                    qty = 10
                end
                
                price_hash.buy_qty = qty.to_s
                
                price_hash.save 
                # duplicate_check = Price.find_by(isbn: row[0])

                # if duplicate_check.blank?
                #     price_hash.save 
                # end

            end
        end
        # trigger slack notification
        #open("https://maker.ifttt.com/trigger/tbm_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end

    def self.import(file, destination)
        require 'csv'
        d = destination.to_s
        if d == "Textbook Recycling"
            ActiveRecord::Base.transaction do
                CSV.foreach(file.path, headers: true) do |row|
                    duplicate_check = Price.find_by(isbn: row[1])
                    
                    if duplicate_check.blank?
                        
                    else
                        title = row[0]
                        vendor_qty = row[3]
                        qty_difference = duplicate_check.buy_qty.to_f - vendor_qty.to_f

                        if qty_difference.to_f <= 0
                            final_qty = duplicate_check.buy_qty
                        else
                            final_qty = vendor_qty
                        end

                        total_float = final_qty.to_f * duplicate_check.amount.to_f
                        total = total_float.to_f


                        duplicate_check.update(title: title, vendor_qty: vendor_qty, qty_difference: qty_difference, final_qty: final_qty, total: total)
                    end

                end
            end
        end

        if d == "Other"
            ActiveRecord::Base.transaction do
                CSV.foreach(file.path, headers: true, col_sep: "\t", liberal_parsing: true, encoding: "macRoman:UTF-8") do |row|
                    duplicate_check = Price.find_by(isbn: row[8])
                    
                    if duplicate_check.blank?
                        
                    else
                        inventory_price = row[10]
                        ip = inventory_price.to_f

                        if duplicate_check.inventory_price.to_f <= ip
                            sold_price = (ip * 0.85) - 5
                            difference = duplicate_check.wholesale_price.to_f - sold_price

                            duplicate_check.update(inventory_price: inventory_price, sold_price: sold_price, difference: difference)
                        end

                    end

                end
            end
        end
        # trigger slack notification
        #open("https://maker.ifttt.com/trigger/valore_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end


    def self.to_csv(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(isbn title amount final_qty total)
            csv << ['ISBN', 'Title', 'Amount', 'QTY', 'Total']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end
end
