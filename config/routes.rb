Rails.application.routes.draw do
  
  devise_for :users
  root to: "homes#top"
  get 'home/about' => 'homes#about', as: 'about'
  resources :books, only: [:index, :show, :edit, :create, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
     get "followers" => "relationships#followers", as: "followers"
  end
  
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  
  get "/search", to: "searches#search"
  
end