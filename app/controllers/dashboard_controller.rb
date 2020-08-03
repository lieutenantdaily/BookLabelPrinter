class DashboardController < ApplicationController
    def index
        @users = User.all

        total_orders_sql = "SELECT order_id AS 'order_id' FROM buybacks WHERE status LIKE '%Review%' GROUP BY order_id"
        total_orders_array = ActiveRecord::Base.connection.execute(total_orders_sql)
        @total_orders = total_orders_array

        total_processing_sql = "SELECT buyback_id AS 'buyback_id' FROM buybacks WHERE status LIKE '%Review%'"
        total_processing_array = ActiveRecord::Base.connection.execute(total_processing_sql)
        @total_processing = total_processing_array

        total_value_sql = "SELECT sum(CAST(REPLACE(price, '$'','') AS float)) AS 'price' FROM buybacks WHERE status LIKE '%Review%'"
        total_value_array = ActiveRecord::Base.connection.execute(total_value_sql)
        @total_value = total_value_array
        @total_value = @total_value.to_s.gsub('[{"price"=>', '').gsub('}]', '')
        @total_value = @total_value.to_f.round(2)


        accepted_orders_a_sql = "SELECT DISTINCT(order_id) FROM buybacks"
        accepted_orders_a_array = ActiveRecord::Base.connection.execute(accepted_orders_a_sql)
        @accepted_orders_a = accepted_orders_a_array

        if @accepted_orders_a.nil?
            @accepted_orders_a = 0
        end

        accepted_processing_sql = "SELECT buyback_id AS 'buyback_id' FROM buybacks WHERE status LIKE '%Keep%' AND status NOT LIKE '%Review%'"
        accepted_processing_array = ActiveRecord::Base.connection.execute(accepted_processing_sql)
        @accepted_processing = accepted_processing_array

        accepted_value_sql = "SELECT sum(CAST(REPLACE(price, '$'','') AS float)) AS 'price' FROM buybacks WHERE status LIKE '%Keep%' AND status NOT LIKE '%Review%'"
        accepted_value_array = ActiveRecord::Base.connection.execute(accepted_value_sql)
        @accepted_value = accepted_value_array
        @accepted_value = @accepted_value.to_s.gsub('[{"price"=>', '').gsub('}]', '')
        @accepted_value = @accepted_value.to_f.round(2)




        # vendor
        v_total_orders_sql = "SELECT order_id AS 'order_id' FROM buybacks WHERE vendor = '" + current_user.custom + "' AND status LIKE '%Review%' GROUP BY order_id"
        v_total_orders_array = ActiveRecord::Base.connection.execute(v_total_orders_sql)
        @v_total_orders = v_total_orders_array

        v_total_processing_sql = "SELECT buyback_id AS 'buyback_id' FROM buybacks WHERE status LIKE '%Review%' AND vendor = '" + current_user.custom + "'"
        v_total_processing_array = ActiveRecord::Base.connection.execute(v_total_processing_sql)
        @v_total_processing = v_total_processing_array

        v_total_value_sql = "SELECT sum(CAST(REPLACE(price, '$'','') AS float)) AS 'price' FROM buybacks WHERE status LIKE '%Review%' AND vendor = '" + current_user.custom + "'"
        v_total_value_array = ActiveRecord::Base.connection.execute(v_total_value_sql)
        @v_total_value = v_total_value_array
        @v_total_value = @v_total_value.to_s.gsub('[{"price"=>', '').gsub('}]', '')
        @v_total_value = @v_total_value.to_f.round(2)


        v_accepted_orders_a_sql = "SELECT DISTINCT(order_id) FROM buybacks WHERE vendor = '" + current_user.custom + "'"
        v_accepted_orders_a_array = ActiveRecord::Base.connection.execute(v_accepted_orders_a_sql)
        @v_accepted_orders_a = v_accepted_orders_a_array

        if @v_accepted_orders_a.nil?
            @v_accepted_orders_a = 0
        end

        v_accepted_processing_sql = "SELECT buyback_id AS 'buyback_id' FROM buybacks WHERE status LIKE '%Keep%' AND vendor = '" + current_user.custom + "'"
        v_accepted_processing_array = ActiveRecord::Base.connection.execute(v_accepted_processing_sql)
        @v_accepted_processing = accepted_processing_array

        v_accepted_value_sql = "SELECT sum(CAST(REPLACE(price, '$'','') AS float)) AS 'price' FROM buybacks WHERE status LIKE '%Keep%' AND vendor = '" + current_user.custom + "'"
        v_accepted_value_array = ActiveRecord::Base.connection.execute(v_accepted_value_sql)
        @v_accepted_value = v_accepted_value_array
        @v_accepted_value = @v_accepted_value.to_s.gsub('[{"price"=>', '').gsub('}]', '')
        @v_accepted_value = @v_accepted_value.to_f.round(2)
    end

    def userPermissions
        userAction = params[:user_action].to_s
        userEmail = params[:user].to_s
        userAdmin = params[:admin].to_s
        userPower = params[:power_user].to_s
        userActive = params[:active].to_s
        userCustom = params[:custom].to_s

        if userAction == "admin"

            if userAdmin == "false" || userAdmin == ""
                sql = "update users set admin = 1 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

            if userAdmin == "true"
                sql = "update users set admin = 0 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

        end

        if userAction == "power_user"

            if userPower == "false" || userPower == ""
                sql = "update users set power_user = 1 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

            if userPower == "true"
                sql = "update users set power_user = 0 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

        end

        if userAction == "active"

            if userActive == "false" || userActive == ""
                sql = "update users set active = 1 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

            if userActive == "true"
                sql = "update users set active = 0 where email = '" + userEmail + "';"
                records_array = ActiveRecord::Base.connection.execute(sql)
            end

        end

        if userAction == "custom"

            sql = "update users set custom = '" + userCustom + "' where email = '" + userEmail + "';"
            records_array = ActiveRecord::Base.connection.execute(sql)

        end

        if userAction == "delete_user"

            sql = "delete from users where email = '" + userEmail + "';"
            records_array = ActiveRecord::Base.connection.execute(sql)

        end

        redirect_to request.referrer
        
    end

end
