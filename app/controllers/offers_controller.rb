class OffersController < ApplicationController
    def index
        @offers = Offer.all.order("created_at DESC")  
        @offers_with_qty = Offer.where.not(quantity: nil)

        respond_to do |format|
          format.html
            format.csv { send_data @offers_with_qty.to_csv, filename: "valore-final-#{@order_id}-#{Date.today}.csv" }
            format.csv2  { send_data @offers.to_csv2, filename: "valore-check-#{@order_id}-#{Date.today}.csv" }
        end
    end
    
    def import
        Offer.import(params[:offer][:file], params[:offer][:destination])
    end

    def import_url
      Offer.import_url
    end
    
    
    def destroy_them_all
        Offer.delete_all
        redirect_to offers_path, notice: "Database has been reset!"
    end 
    
    def new
        @offer = Offer.new
    end
    
      def update
        @offer = Offer.find(params[:id])
    
        if @offer.update_attributes(offer_params)
          flash[:success] = "Task updated!"
          redirect_to url
        end
        
      end
    
      def create
        Offer.import(params[:offer][:file], params[:offer][:destination])
        flash[:notice] = "Buybacks uploaded successfully"
        redirect_to offers_path
      end
      
      private def offer_params
        params.require(:offer).permit(:file, :destination) 
      end
end
