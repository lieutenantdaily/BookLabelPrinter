Rails.application.routes.draw do

  root 'buybacks#index', as: 'home'
  post "buybacks/destroy_them_all" 


  resources :orders
  resources :buybacks
  
  get 'links' => 'pages#links', as: 'links'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
