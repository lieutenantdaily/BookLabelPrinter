class Offer < ApplicationRecord
    # Bulk upload 
    def self.import_url()
        require 'csv'
        require 'open-uri'
        csv_path = open('http://metabase.textbookmaniac.com/public/question/543a1532-0ed1-411c-8075-6484acce0fd4.csv', :read_timeout => 300)
        # name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        Offer.delete_all
        CSV.foreach(csv_path, headers: true) do |row|
            offer_hash = Offer.new
            offer_hash.isbn = row[0]
            offer_hash.tbm_amount = row[1]
            offer_hash.rank = row[2]
            offer_hash.min_qty = 1
            offer_hash.minimum = 5.02
            duplicate_check = Offer.find_by(isbn: row[0])

            if duplicate_check.blank?
                offer_hash.save 
            end

        end
        # trigger slack notification
        open("https://maker.ifttt.com/trigger/tbm_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end

    def self.import(file, destination)
        require 'csv'
        d = destination.to_s
        # name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        if d == "TBM Prices"
            Offer.delete_all
            CSV.foreach(file.path, headers: true) do |row|
                offer_hash = Offer.new
                offer_hash.isbn = row[0]
                offer_hash.tbm_amount = row[1]
                offer_hash.rank = row[2]
                offer_hash.min_qty = 1
                offer_hash.minimum = 5.02
                offer_hash.save 

                # duplicate_check = Offer.find_by(isbn: row[0])

                # if duplicate_check.blank?
                #     offer_hash.save 
                # end

            end
        end
        if d == "Valore Prices"
            CSV.foreach(file.path, headers: true) do |row|
                offer_hash = Offer.new
                offer_hash.isbn = row[0]
                offer_hash.suggested_bid = row[4]
                duplicate_check = Offer.find_by(isbn: row[0])
                
                if duplicate_check.blank?
                    # offer_hash.save 
                else
                    duplicate_check.update(suggested_bid: row[4])

                    rank = duplicate_check.rank.to_f
                    suggested_bid = duplicate_check.suggested_bid.to_f
                    tbm_amount = duplicate_check.tbm_amount.to_f
                    diff = suggested_bid - tbm_amount

                    if rank < 4000000 && rank >= 700000
                        duplicate_check.update(quantity: 1)
                    end
                    
                    if rank < 700000 && rank >= 600000
                        duplicate_check.update(quantity: 2)
                    end
                    
                    if rank < 600000 && rank >= 500000
                        duplicate_check.update(quantity: 3)
                    end
                    
                    if rank < 500000 && rank >= 400000
                        duplicate_check.update(quantity: 4)
                    end
                    
                    if rank < 400000 && rank >= 300000
                        duplicate_check.update(quantity: 5)
                    end
                    
                    if rank < 300000 && rank >= 200000
                        duplicate_check.update(quantity: 6)
                    end

                    if rank < 200000 && rank >= 150000
                        duplicate_check.update(quantity: 7)
                    end

                    if rank < 150000 && rank >= 100000
                        duplicate_check.update(quantity: 8)
                    end

                    if rank < 100000 && rank >= 50000
                        duplicate_check.update(quantity: 9)
                    end

                    if rank < 50000
                        duplicate_check.update(quantity: 10)
                    end

                    if suggested_bid > 5.02 && diff <= 0
                        bid = suggested_bid + 0.01
                        duplicate_check.update(bid: bid)
                    end

                    if suggested_bid > 5.02 && diff > 0 && diff < 2.5
                        bid = suggested_bid + 0.01
                        duplicate_check.update(bid: bid)
                    end

                    if suggested_bid > 5.02 && diff >= 2.5
                        bid = tbm_amount + 2.5
                        duplicate_check.update(bid: bid)
                    end

                    if suggested_bid <= 5.02
                        bid = tbm_amount / 2
                        if bid < 5.02
                            bid = 5.02
                        end
                        duplicate_check.update(bid: bid)
                    end

                end

            end
        end
        # trigger slack notification
        open("https://maker.ifttt.com/trigger/valore_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end

    def self.to_csv(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(isbn quantity bid)
            csv << ['isbn', 'quantity', 'bid']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end

    def self.to_csv2(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(isbn min_qty minimum)
            csv << ['isbn', 'quantity', 'bid']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end


end
