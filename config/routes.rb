Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :login, only:[:create]

  get 'logout', to: :show, controller: 'logout'
#  resources :logout do
#    get "logout" ,on: :collection 
#  end
  resources :users, only: [:index, :create, :show, :destroy] #do 
    #post "delete", on: :collection
  #each_with_index
  post "users/:id", to: 'users#update'
end
