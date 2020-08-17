class ItemsController < ApplicationController
    
  # validates_length_of :search, minimum: 5, maximum: 45, allow_blank: true

  def index
    @all_buybacks = Buyback.all.where.not(vendor: "xxxxxxxxxxx")

    @all_orders = @all_buybacks.order("created_at DESC").select("DISTINCT(order_id)")
    
    @summary_buybacks_counter = Buyback.all.order("isbn ASC")

    # vendor --------------------
    @vendor_all_buybacks = Buyback.all.where(vendor: current_user.custom)

    @vendor_all_orders = @vendor_all_buybacks.order("created_at DESC").select("DISTINCT(order_id)")

    @vendor_summary_buybacks_counter = Buyback.where(vendor: current_user.custom).order("isbn ASC")

    # ---------------------------



    if params[:search]
      @buybacks = Buyback.search(params[:search]).order("isbn ASC")
      @buybacks_counter = Buyback.search(params[:search]).order("isbn ASC")
      @buybacks_keep = Buyback.search(params[:search]).where(status: ["Keep-Acceptable", "Keep-Good", "Keep-Very Good", "Keep-Like New", "Keep-New"]).order("isbn ASC")
      @buybacks_reject = Buyback.search(params[:search]).where(status: ["Reject-Red", "Reject-Yellow", "Reject-Blue", "Missing"]).order("isbn ASC")
      @buybacks_tracking = Buyback.search(params[:search]).order("created_at DESC").select("tracking_number2, shipper").group("tracking_number2")
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



      # vendor --------------------
      @vendor_buybacks = Buyback.where(vendor: current_user.custom).search(params[:search]).order("isbn ASC")
      @vendor_buybacks_counter = Buyback.where(vendor: current_user.custom).search(params[:search]).order("isbn ASC")
      @vendor_buybacks_keep = Buyback.where(vendor: current_user.custom).search(params[:search]).where(status: ["Keep-Acceptable", "Keep-Good", "Keep-Very Good", "Keep-Like New", "Keep-New"]).order("isbn ASC")
      @vendor_buybacks_reject = Buyback.where(vendor: current_user.custom).search(params[:search]).where(status: ["Reject-Red", "Reject-Yellow", "Reject-Blue", "Missing"]).order("isbn ASC")

      
      if params[:isbn]
        unless params[:isbn].empty?
          @vendor_buybacks = Buyback.where(vendor: current_user.custom).search(params[:search]).where(isbn: params[:isbn]).order("isbn ASC")
          session[:passed_variable2] = @isbn_params
        end
      end
      # ---------------------------
      

      
      

      b = @buybacks

      b[0,1].each do |bb|
        @order_id = bb.order_id
        @box_id = bb.tracking_number
        @isbn = bb.isbn
      end


      # vendor --------------------
      if @vendor_buybacks.present?
        vb = @vendor_buybacks

        vb[0,1].each do |bb|
          @vendor_order_id = bb.order_id
          @vendor_box_id = bb.tracking_number
          @vendor_isbn = bb.isbn
        end
      end
      # ---------------------------




      @filtered_buybacks = Buyback.filtered_search(@order_id).where(isbn: [@isbn])




      # vendor --------------------
      if @vendor_buybacks.present?
        @vendor_filtered_buybacks = Buyback.filtered_search(@vendor_order_id).where(isbn: [@vendor_isbn])
      end
      # ---------------------------

      

      @boxcount = Buyback.search(@order_id).group(:tracking_number).count
      @filtered_by_box = Buyback.search(@box_id)
      @filtered_by_box_reviewed = @filtered_by_box.where(status: ["Review", "Review-Keep"])
      @filtered_by_box_reject_no_notes = @filtered_by_box.where(status: ["Reject-Blue", "Reject-Yellow"]).where(notes: "")

      # vendor --------------------
      if @vendor_buybacks.present?
        @vendor_boxcount = Buyback.search(@vendor_order_id).group(:tracking_number).count
        @vendor_filtered_by_box = Buyback.search(@vendor_box_id)
        @vendor_filtered_by_box_reviewed = @vendor_filtered_by_box.where(status: ["Review", "Review-Keep"])
        @vendor_filtered_by_box_reject_no_notes = @vendor_filtered_by_box.where(status: ["Reject-Blue", "Reject-Yellow"]).where(notes: "")
      end
      # ---------------------------

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

      # vendor --------------------
      if @vendor_buybacks.present?
        if session[:passed_variable] == @vendor_order_id
          vendor_sum_total_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE order_id = " + @order_id
          vendor_sum_total_array = ActiveRecord::Base.connection.execute(vendor_sum_total_sql)
          @vendor_sum_total = vendor_sum_total_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @vendor_sum_total = @vendor_sum_total.to_f.round(2)

          vendor_sum_reject_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Reject-Red', 'Reject-Yellow', 'Reject-Blue') AND order_id = " + @vendor_order_id
          vendor_sum_reject_array = ActiveRecord::Base.connection.execute(vendor_sum_reject_sql)
          @vendor_sum_reject = vendor_sum_reject_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @vendor_sum_reject = @vendor_sum_reject.to_f.round(2)

          vendor_sum_keep_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Keep-Acceptable', 'Keep-Good', 'Keep-Very Good', 'Keep-Like New', 'Keep-New') AND order_id = " + @vendor_order_id
          vendor_sum_keep_array = ActiveRecord::Base.connection.execute(vendor_sum_keep_sql)
          @vendor_sum_keep = vendor_sum_keep_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @vendor_sum_keep = @vendor_sum_keep.to_f.round(2)

          vendor_sum_missing_sql = "SELECT SUM(CAST( REPLACE(price, '$', '') AS FLOAT)) AS 'total' FROM buybacks WHERE status IN ('Missing') AND order_id = " + @vendor_order_id
          vendor_sum_missing_array = ActiveRecord::Base.connection.execute(vendor_sum_missing_sql)
          @vendor_sum_missing = vendor_sum_missing_array.to_s.gsub('[{"total"=>', '').gsub('}]', '')
          @vendor_sum_missing = @vendor_sum_missing.to_f.round(2)
        end
      end
      # ---------------------------
      

      # @sum_keep = @sum_total.where(status: ["Keep-Acceptable", "Keep-Good", "Keep-Very Good", "Keep-Like New", "Keep-New"])
      # @sum_rejected = @sum_total.where(status: ["Reject-Red", "Reject-Yellow", "Reject-Blue"])
      
      respond_to do |format|
        format.html
          format.csv { send_data @buybacks_keep.to_csv, filename: "keep-#{@order_id}-#{Date.today}.csv" }
          format.csv2  { send_data @buybacks_reject.to_csv2, filename: "returns-#{@order_id}-#{Date.today}.csv" }
          format.csv3  { send_data @buybacks.to_csv3, filename: "all-#{@order_id}-#{Date.today}.csv" }
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

    @filtered_buybacks = Buyback.filtered_search(@order_id).where(isbn: [@isbn]).where.not(buyback_id: [@buyback_id]).where.not(status: ["Reject-Red"]).where.not(status: ["Missing"])

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

  def addTracking
    addTracking = params[:tracking_number2].to_s
    addShipper = params[:shipper].to_s
    addTrackingOrderID = params[:addTrackingOrderID].to_s

    sql = "update buybacks set shipper = '" + addShipper + "' where order_id = '" + addTrackingOrderID + "';"
    records_array = ActiveRecord::Base.connection.execute(sql)

    sql = "update buybacks set tracking_number2 = '" + addTracking + "' where order_id = '" + addTrackingOrderID + "';"
    records_array = ActiveRecord::Base.connection.execute(sql)

    redirect_to request.referrer
  end

  def create
    @current_user = current_user
    Buyback.import(params[:buyback][:file], params[:buyback][:destination], params[:buyback][:initials], params[:buyback][:user_custom], params[:buyback][:append], params[:buyback][:append_vendor], params[:buyback][:append_order_id], params[:buyback][:append_source], params[:buyback][:add_isbn], params[:buyback][:add_price], params[:buyback][:add_qty], params[:buyback][:add_select], params[:buyback][:shipper], params[:buyback][:tracking_number])
    
    if params[:buyback][:append].to_s == "Append Current Order"
      flash[:notice] = "Book(s) added"
      redirect_to buybacks_path + "?search=" + params[:buyback][:append_order_id].to_s
    else
      flash[:notice] = "Order uploaded!"
      redirect_to buybacks_path
    end
  end
  
  private def buyback_params
    params.require(:buyback).permit(:file, :destination, :notes, :status, :initials, :user_custom, :append, :append_order_id, :append_vendor, :append_source, :add_isbn, :add_price, :add_qty, :add_select, :shipper, :tracking_number) 
  end

end
