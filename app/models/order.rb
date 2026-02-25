class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum status: { pending: 0, confirmed: 1, canceled: 2 }

  validates :status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
end
