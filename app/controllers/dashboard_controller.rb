class DashboardController < ApplicationController
    def index
        @users = User.all
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
