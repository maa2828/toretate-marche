class Product < ApplicationRecord
  # リレーション
  belongs_to :seller, class_name: 'User'
  has_one_attached :image
  
  # Enum
  enum status: { draft: 0, published: 1, sold_out: 2 }
  
  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  
  # 画像のバリデーション
  validate :image_type_and_size
  
  private
  
  def image_type_and_size
    return unless image.attached?
    
    # ファイル形式のチェック
    unless image.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:image, 'はJPEG、PNG、GIF形式のみアップロード可能です')
    end
    
    # ファイルサイズのチェック（5MB = 5 * 1024 * 1024 bytes）
    if image.blob.byte_size > 5.megabytes
      errors.add(:image, 'は5MB以下にしてください')
    end
  end
end
