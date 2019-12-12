class CompareFile < ApplicationRecord
    # Bulk upload 
    def self.import_url()
        require 'csv'
        require 'open-uri'
        csv_path = open('http://metabase.textbookmaniac.com/public/question/4e01a916-c763-4a51-9c51-f84cc12c976c.csv', :read_timeout => 300)
        # name = file.original_filename.gsub("valorebooks-shipment-details-","")[0,6]
        CompareFile.delete_all
        ActiveRecord::Base.transaction do
            CSV.foreach(csv_path, headers: true) do |row|
                compare_file_hash = CompareFile.new
                compare_file_hash.isbn = row[0]
                compare_file_hash.wholesale_price = row[1]
                # ip = compare_file_hash.inventory_price.to_f
                # compare_file_hash.sold_price = (ip * 0.85) - 5
                duplicate_check = CompareFile.find_by(isbn: row[0])

                if duplicate_check.blank?
                    compare_file_hash.save 
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
                    duplicate_check = CompareFile.find_by(isbn: row[16])
                    
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
