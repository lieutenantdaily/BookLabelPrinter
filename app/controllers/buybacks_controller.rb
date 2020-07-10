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
      session[:passed_variable2] = ""
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

  def destroy_this_order
    Buyback.search(session[:passed_variable]).delete_all
    redirect_to buybacks_path, notice: "Order deleted!"
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
    @search_isbn = ""

    @filtered_buybacks = Buyback.filtered_search(@order_id).where(isbn: [@isbn]).where.not(buyback_id: [@buyback_id]).where.not(status: ["Reject-Red"])

    if $last_isbn == @isbn
      @search_isbn = @isbn
    end
    
    

    if @buyback.update_attributes(buyback_params)
      if session[:passed_variable] == @buyback_id
        if buyback_params[:status] == "Keep-Acceptable" || buyback_params[:status] == "Keep-Good" || buyback_params[:status] == "Keep-Very Good" || buyback_params[:status] == "Keep-Like New" || buyback_params[:status] == "Keep-New"
          url = "/buybacks?search=" + session[:passed_variable] + "&tempparam1=" + @order_id + "&tempparam2=" + "" + "&script=PRINT-VX#" + @buyback_id
        else
          url = "/buybacks?search=" + @order_id + "&isbn=" + "" + "#" + @buyback_id
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

      flash[:success] = "Saved!"
      redirect_to url
    end
    
  end

  def create
    @current_user = current_user
    Buyback.import(params[:buyback][:file], params[:buyback][:destination], params[:buyback][:initials], params[:buyback][:user_custom], params[:buyback][:append], params[:buyback][:append_vendor], params[:buyback][:append_order_id], params[:buyback][:append_source], params[:buyback][:add_isbn], params[:buyback][:add_price], params[:buyback][:add_qty], params[:buyback][:add_select])
    
    if params[:buyback][:append].to_s == "Append Current Order"
      flash[:notice] = "Books added!"
      redirect_to buybacks_path + "?search=" + params[:buyback][:append_order_id].to_s
    else
      flash[:notice] = "Order uploaded!"
      redirect_to buybacks_path
    end
  end
  
  private def buyback_params
    params.require(:buyback).permit(:file, :destination, :notes, :status, :initials, :user_custom, :append, :append_order_id, :append_vendor, :append_source, :add_isbn, :add_price, :add_qty, :add_select) 
  end


end
