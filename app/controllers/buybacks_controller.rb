class BuybacksController < ApplicationController

  # validates_length_of :search, minimum: 5, maximum: 45, allow_blank: true

  def index
    if params[:search]
      @buybacks = Buyback.search(params[:search]).order("created_at DESC")

    else
    end

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
