class BuybacksController < ApplicationController

  # validates_length_of :search, minimum: 5, maximum: 45, allow_blank: true

  def index
    @all_buybacks = Buyback.all.order("created_at DESC")
    if params[:search]
      @buybacks = Buyback.search(params[:search]).order("buyback_id DESC")
      @buybacks_keep = Buyback.search(params[:search]).where(status: "Keep").order("buyback_id DESC")
      
      

      b = @buybacks

      b[0,1].each do |bb|
        @order_id = bb.order_id
      end

      @boxcount = Buyback.search(@order_id).group(:tracking_number).count
      
      respond_to do |format|
        format.html
        format.csv { send_data @buybacks_keep.to_csv, filename: "valore-#{@order_id}-#{Date.today}.csv" }
      end

    else

    end

  end

  def import
    Buyback.import(params[:buyback][:file], params[:buyback][:destination])
  end


  def destroy_them_all
    Buyback.delete_all
    redirect_to home_path, notice: "Database has been reset!"
  end 

  def new
    @buyback = Buyback.new#(buyback_params)
  end

  def update
    @buyback = Buyback.find(params[:id])

    b = @buyback


    @order_id = b.order_id
    @tracking_number = b.tracking_number
    @buyback_id = b.buyback_id
    
  

    url = "/buybacks?search=" + @tracking_number + "#" + @buyback_id
    
    if @buyback.update_attributes(buyback_params)
      flash[:success] = "Task updated!"
      redirect_to url
    end
    
  end

  def create
    Buyback.import(params[:buyback][:file], params[:buyback][:destination], params[:buyback][:initials])
    flash[:notice] = "Buybacks uploaded successfully"
    redirect_to home_path 
  end

  # def buyback_params
  #   params.require(:buyback).permit(:file, :destination)
  # end

  
  private def buyback_params
    params.require(:buyback).permit(:file, :destination, :notes, :status, :initials) 
 end

end
