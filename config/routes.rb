Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#index"

  get "add/", to: "pages#new", as: :add_page
  get "", to: "pages#index", as: :pages
  post "", to: "pages#create", as: :create_page

  resources :pages, path: "(*path)", only: [:show] do
    get "add", to: "pages#new", as: :new_page, on: :member
  end

end
