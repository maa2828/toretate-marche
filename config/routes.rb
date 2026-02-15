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
  resource :cart, only: [:show], controller: 'carts' do
    post 'add_item/:product_id', to: 'carts#add_item', as: :add_item
    patch 'update_item/:product_id', to: 'carts#update_item', as: :update_item
    delete 'remove_item/:product_id', to: 'carts#remove_item', as: :remove_item
    delete 'clear', to: 'carts#clear'
  end
  
  # ホーム画面
  get 'home', to: 'home#index'
  root 'home#index'
end
