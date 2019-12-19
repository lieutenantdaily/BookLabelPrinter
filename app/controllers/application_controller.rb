class ApplicationController < ActionController::Base
    http_basic_authenticate_with :name => "infinitybooks", :password => "wareagle",except: [:links]
end
