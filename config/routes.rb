Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'fitbit/:resource/:date.json' => 'fitbit_api#data_request'

 
end
