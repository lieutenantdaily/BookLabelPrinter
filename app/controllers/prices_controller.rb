class PricesController < ApplicationController
    
    def index
        @prices = Price.all.order("created_at DESC") 
        @prices_with_diff = Price.where("final_qty > ?", 0).order("CAST(rank AS Decimal) DESC") 
    
        respond_to do |format|
            format.html
              format.csv { send_data @prices_with_diff.to_csv, filename: "bid-#{Date.today}.csv" }
        end
        @counter = Price.all.count
        @counter2 = @prices_with_diff.all.count
    end

    def import_url
        Price.import_url
        redirect_to prices_path, notice: "Nebraska Import Complete"
    end

    def import_url_rat
        Price.import_url_tex
        redirect_to prices_path, notice: "Texas Import Complete"
    end

    def destroy_them_all
        Price.delete_all
        redirect_to prices_path, notice: "Database has been reset!"
    end 

    def new
        @price = Price.new
    end

    def update
        @price = Price.find(params[:id])
    
        if @price.update_attributes(price_params)
          flash[:success] = "Task updated!"
          redirect_to url
        end
        
    end
    
    def create
        Price.import(params[:price][:file], params[:price][:destination])
        # flash[:notice] = "Buybacks uploaded successfully"
        redirect_to prices_path
    end

    private def price_params
        params.require(:price).permit(:file, :destination) 
    end
end
