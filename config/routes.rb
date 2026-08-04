# config/routes.rb
Rails.application.routes.draw do
  root "dashboard#index"
  resources :error_events, only: [:index, :new, :create, :show]
  resources :incidents, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end

