Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # 商品関連のルーティング
  resources :products
  
  # ホーム画面
  get 'home', to: 'home#index'
  root 'home#index'
end
