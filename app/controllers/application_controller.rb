class ApplicationController < ActionController::Base
    # http_basic_authenticate_with :name => "infinitybooks", :password => "wareagle",except: [:links]
    before_action :authenticate_user!

    protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password)}
          end
end
