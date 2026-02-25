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
  
  # カート機能
  get 'cart', to: 'carts#show', as: 'cart'
  post 'cart/add/:product_id', to: 'carts#add_item', as: 'cart_add_item'
  patch 'cart/update/:product_id', to: 'carts#update_item', as: 'cart_update_item'
  delete 'cart/remove/:product_id', to: 'carts#remove_item', as: 'cart_remove_item'
  delete 'cart/clear', to: 'carts#clear', as: 'cart_clear'
  
  # 注文機能
  resources :orders, only: [:index, :show, :new, :create]
  
  # ホーム画面
  get 'home', to: 'home#index'
  root 'home#index'
end
