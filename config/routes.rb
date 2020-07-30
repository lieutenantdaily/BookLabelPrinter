Rails.application.routes.draw do

  devise_for :users
  root 'dashboard#index', as: 'home'
  post "buybacks/destroy_them_all" 
  post "buybacks/destroy_this_order" 

  post "offers/destroy_them_all" 
  post "offers/import_url" 
  post "offers/import_url_neb" 

  post "compare_files/destroy_them_all" 
  post "compare_files/import_url" 
  post "compare_files/import_url_tex" 

  post "prices/destroy_them_all" 
  post "prices/import_url" 
  post "prices/import_url_rat" 

  get '/userPermissions', to: 'dashboard#userPermissions', as: 'userPermissions'
  get '/addTracking', to: 'buybacks#addTracking', as: 'addTracking'
  # get '/userPermissionsDelete', to: 'dashboard#userPermissionsDelete', as: 'userPermissionsDelete'
  # get '/userPermissionsMakeAdmin', to: 'dashboard#userPermissionsMakeAdmin', as: 'userPermissionsMakeAdmin'

  resources :orders
  resources :buybacks
  resources :offers
  resources :compare_files
  resources :prices
  resources :dashboard


  
  get 'links' => 'pages#links', as: 'links'
  get 'no_shipping' => 'pages#no_shipping', as: 'no_shipping'
  get 'other_shipping' => 'pages#other_shipping', as: 'other_shipping'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
