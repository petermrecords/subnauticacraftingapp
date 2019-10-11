Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [] do
  	resources :lists
  end

  resources :lists, only: [] do
    resources :list_materials, only: [:create, :update, :destroy]
  end

  get "materials/select", to: "materials#select"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
end
