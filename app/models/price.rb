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
                price_hash.wholesale_price = row[1]
                # ip = compare_file_hash.inventory_price.to_f
                # compare_file_hash.sold_price = (ip * 0.85) - 5
                duplicate_check = Price.find_by(isbn: row[0])

                if duplicate_check.blank?
                    price_hash.save 
                end

            end
        end
        # trigger slack notification
        # open("https://maker.ifttt.com/trigger/tbm_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end

    def self.import_url_tex()
        require 'csv'
        require 'open-uri'
        csv_path = open('http://metabase.textbookmaniac.com/public/question/87285a19-1cd2-47b1-b90d-a94be2517348.csv', :read_timeout => 300)
        # name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        Price.delete_all
        ActiveRecord::Base.transaction do
            CSV.foreach(csv_path, headers: true) do |row|
                price_hash = Price.new
                price_hash.isbn = row[0]
                price_hash.wholesale_price = row[1]
                # ip = compare_file_hash.inventory_price.to_f
                # compare_file_hash.sold_price = (ip * 0.85) - 5
                duplicate_check = Price.find_by(isbn: row[0])

                if duplicate_check.blank?
                    price_hash.save 
                end

            end
        end
        # trigger slack notification
        # open("https://maker.ifttt.com/trigger/tbm_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end

    def self.import(file, destination)
        require 'csv'
        d = destination.to_s
        if d == "SellerEngine"
            ActiveRecord::Base.transaction do
                CSV.foreach(file.path, headers: true, col_sep: "\t", liberal_parsing: true, encoding: "macRoman:UTF-8") do |row|
                    duplicate_check = Price.find_by(isbn: row[16])
                    
                    if duplicate_check.blank?
                        
                    else
                        inventory_price = row[6]
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

        if d == "Fillz"
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
        # open("https://maker.ifttt.com/trigger/valore_complete/with/key/c1U8i7gQQ8kx8uN-GlCPbboQj_3bOh43lRu5E7BCsFH")
    end


    def self.to_csv(options = {})
        require 'csv'
        CSV.generate(options) do |csv|
            columns = %w(isbn inventory_price sold_price wholesale_price difference)
            csv << ['isbn', 'inventory_price', 'sold_price', 'wholesale_price', 'difference']
            all.each do |product|
                csv << product.attributes.values_at(*columns)
            end
        end
    end
end
