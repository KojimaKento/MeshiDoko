class Favorite < ApplicationRecord
  # アソシエーション
  belongs_to :restaurant

  # バリデーション
  validates :restaurant_id, presence: { message: 'を入力してください' }
end
