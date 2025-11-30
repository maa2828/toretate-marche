Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # 仮のホーム画面を作成
  get 'home', to: 'home#index'
  root 'home#index'
end
