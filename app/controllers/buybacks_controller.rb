class BuybacksController < ApplicationController
  
  # validates_length_of :search, minimum: 5, maximum: 45, allow_blank: true

  def index
    @all_buybacks = Buyback.all.order("created_at DESC")

    @all_orders = Buyback.group(:order_id).order("created_at DESC")
    # @all_orders = Buyback.select("DISTINCT ON (order_id) created_at, order_id").order('created_at DESC')



    if params[:search]
      @buybacks = Buyback.search(params[:search]).order("isbn ASC")
      @buybacks_counter = Buyback.search(params[:search]).order("isbn ASC")
      @buybacks_keep = Buyback.search(params[:search]).where(status: ["Keep-Acceptable", "Keep-Good", "Keep-Very Good", "Keep-Like New", "Keep-New"]).order("isbn ASC")
      @buybacks_reject = Buyback.search(params[:search]).where(status: ["Reject-Red", "Reject-Yellow", "Reject-Blue", "Missing"]).order("isbn ASC")
      @search_params = params[:search]
      @isbn_params = params[:isbn]
      session[:passed_variable] = @search_params
      
      @breakeven = 0.85

      if params[:isbn]
        unless params[:isbn].empty?
          @buybacks = Buyback.search(params[:search]).where(isbn: params[:isbn]).order("isbn ASC")
          session[:passed_variable2] = @isbn_params
        end
      end
      

      
      

      b = @buybacks

      b[0,1].each do |bb|
        @order_id = bb.order_id
        @box_id = bb.tracking_number
        @isbn = bb.isbn
      end

      @filtered_buybacks = Buyback.filtered_search(@order_id).where(isbn: [@isbn])

      

      @boxcount = Buyback.search(@order_id).group(:tracking_number).count
      @filtered_by_box = Buyback.search(@box_id)
      @filtered_by_box_reviewed = @filtered_by_box.where(status: ["Review", "Review-Keep"])
      @filtered_by_box_reject_no_notes = @filtered_by_box.where(status: ["Reject-Blue", "Reject-Yellow"]).where(notes: "")

      if @buybacks.present?
        if session[:passed_variable] == @order_id
          sum_total_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE order_id = " + @order_id
          sum_total_array = ActiveRecord::Base.connection.execute(sum_total_sql)
          @sum_total = sum_total_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @sum_total = @sum_total.to_f.round(2)

          sum_reject_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Reject-Red', 'Reject-Yellow', 'Reject-Blue') AND order_id = " + @order_id
          sum_reject_array = ActiveRecord::Base.connection.execute(sum_reject_sql)
          @sum_reject = sum_reject_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @sum_reject = @sum_reject.to_f.round(2)

          sum_keep_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Keep-Acceptable', 'Keep-Good', 'Keep-Very Good', 'Keep-Like New', 'Keep-New') AND order_id = " + @order_id
          sum_keep_array = ActiveRecord::Base.connection.execute(sum_keep_sql)
          @sum_keep = sum_keep_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @sum_keep = @sum_keep.to_f.round(2)

          sum_missing_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Missing') AND order_id = " + @order_id
          sum_missing_array = ActiveRecord::Base.connection.execute(sum_missing_sql)
          @sum_missing = sum_missing_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @sum_missing = @sum_missing.to_f.round(2)
        end
      end
      

      # @sum_keep = @sum_total.where(status: ["Keep-Acceptable", "Keep-Good", "Keep-Very Good", "Keep-Like New", "Keep-New"])
      # @sum_rejected = @sum_total.where(status: ["Reject-Red", "Reject-Yellow", "Reject-Blue"])
      
      respond_to do |format|
        format.html
          format.csv { send_data @buybacks_keep.to_csv, filename: "valore-keep-#{@order_id}-#{Date.today}.csv" }
          format.csv2  { send_data @buybacks_reject.to_csv2, filename: "valore-returns-#{@order_id}-#{Date.today}.csv" }
          format.csv3  { send_data @buybacks.to_csv3, filename: "valore-all-#{@order_id}-#{Date.today}.csv" }
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
    @isbn = b.isbn
    @status = b.status

    @filtered_buybacks = Buyback.filtered_search(@order_id).where(isbn: [@isbn]).where.not(buyback_id: [@buyback_id]).where.not(status: ["Reject-Red"])
    
    

    if @buyback.update_attributes(buyback_params)
      if session[:passed_variable] == @buyback_id
        if buyback_params[:status] == "Keep-Acceptable" || buyback_params[:status] == "Keep-Good" || buyback_params[:status] == "Keep-Very Good" || buyback_params[:status] == "Keep-Like New" || buyback_params[:status] == "Keep-New"
          url = "/buybacks?search=" + session[:passed_variable] + "&script=PRINT-VX#" + @buyback_id
        else
          url = "/buybacks?search=" + session[:passed_variable] + "#" + @buyback_id
        end
      else
        url = "/buybacks?search=" + session[:passed_variable] + "&isbn=" + session[:passed_variable2] + "#" + @buyback_id
      end
      
      if @status == "Review"
        if buyback_params[:status] == "Reject-Yellow" || buyback_params[:status] == "Reject-Blue"
          @filtered_buybacks.update_all(:status => buyback_params[:status])
        end

        if buyback_params[:status] == "Keep-Acceptable" || buyback_params[:status] == "Keep-Good" || buyback_params[:status] == "Keep-Very Good" || buyback_params[:status] == "Keep-Like New" || buyback_params[:status] == "Keep-New"
          @filtered_buybacks.update_all(:status => "Review-Keep")
        end
      end

      flash[:success] = "Task updated!"
      redirect_to url
    end
    
  end

  def create
    Buyback.import(params[:buyback][:file], params[:buyback][:destination], params[:buyback][:initials])
    flash[:notice] = "Buybacks uploaded successfully"
    redirect_to buybacks_path 
  end
  
  private def buyback_params
    params.require(:buyback).permit(:file, :destination, :notes, :status, :initials) 
  end


end
