class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum for role - buyerをconsumerに変更
  enum role: { consumer: 0, seller: 1 }
  
  # Validations
  validates :name, presence: true
  validates :role, presence: true
end
