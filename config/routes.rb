Rails.application.routes.draw do

  root 'buybacks#index', as: 'home'
  post "buybacks/destroy_them_all" 

  post "offers/destroy_them_all" 
  post "offers/import_url" 


  resources :orders
  resources :buybacks
  resources :offers
  
  get 'links' => 'pages#links', as: 'links'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
