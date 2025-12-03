class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum for role
  enum role: { consumer: 0, seller: 1 }
  
  # リレーション
  has_many :products, foreign_key: :seller_id, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :role, presence: true
end
