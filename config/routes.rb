Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # 商品関連のルーティング
  resources :products do
    member do
      patch :toggle_status
    end
  end
  
  # ホーム画面
  get 'home', to: 'home#index'
  root 'home#index'
end
docker-compose up
