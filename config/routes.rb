Rails.application.routes.draw do

  root 'buybacks#index', as: 'home'
  post "buybacks/destroy_them_all" 

  post "offers/destroy_them_all" 
  post "offers/import_url" 
  post "offers/import_url_neb" 

  post "compare_files/destroy_them_all" 
  post "compare_files/import_url" 
  post "compare_files/import_url_tex" 

  post "prices/destroy_them_all" 
  post "prices/import_url" 
  post "prices/import_url_rat" 


  resources :orders
  resources :buybacks
  resources :offers
  resources :compare_files
  resources :prices
  
  get 'links' => 'pages#links', as: 'links'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
