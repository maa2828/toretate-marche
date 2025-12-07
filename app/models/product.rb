class Product < ApplicationRecord
  # リレーション
  belongs_to :seller, class_name: 'User'
  has_many_attached :images
  
  # Enum
  enum status: { draft: 0, published: 1, sold_out: 2 }
  
  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  # validates :images, presence: true  ← この行を削除またはコメントアウト
  
  # スコープ
  scope :published_items, -> { where(status: :published).order(created_at: :desc) }
end
