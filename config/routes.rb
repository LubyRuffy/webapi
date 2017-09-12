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

  ########templates#############
  resources :templates, only: [:new, :index, :show, :create] do
	post:delete, on: :collection
  end
  post 'templates/:id', :to =>'templates#update'

  ########scans#################
  resources :scans, only: [:index,:new, :show, :create] do
	post:delete, on: :collection
	post :start, on: :member
	post :pause, on: :member
	post :resume, on: :member
	post :stop, on: :member	
	post :repeat, on: :member
  end
  post 'scans/:id', :to =>'scans#update'

  resources :diskchecks, only: [:index, :create]

  ############################
end
