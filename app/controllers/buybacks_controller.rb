class BuybacksController < ApplicationController

  # validates_length_of :search, minimum: 5, maximum: 45, allow_blank: true

  def index
    @all_buybacks = Buyback.all.order("created_at DESC")
    if params[:search]
      @buybacks = Buyback.search(params[:search]).order("buyback_id DESC")

    else

    end

  end


  def destroy_them_all
    Buyback.delete_all
    redirect_to home_path, notice: "Database has been reset!"
  end 

  def new
    @buyback = Buyback.new
  end

  def create
    Buyback.import(params[:buyback][:file])
    flash[:notice] = "Buybacks uploaded successfully"
    redirect_to home_path #=> or where you want
  end
end
