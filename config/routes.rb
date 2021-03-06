Rails.application.routes.draw do

  resources :stocks

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :leads do 
    collection do 
      get 'upload_csv', to: 'leads#upload_csv'
      post 'upload_csv', to: 'leads#upload_csv_post'
    end
    member do 
      post 'confirm'
      post 'call'
    end
  end


  post 'call', to: 'twilio#call'
  post 'forward', to: 'twilio#forward'

  get 'test', to: 'pages#test'
  post 'test', to: 'pages#test_trends'




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'leads#index'
  root 'pages#main'
end
