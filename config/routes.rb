Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "main#index"

  get 'ad', to: 'main#ad'

  post 'create_order', to: 'main#create_order'
end
