class Restaurant < ApplicationRecord
  # アソシエーション
  has_many :favorites, dependent: :destroy

  # バリデーション
  validates :name, presence: { message: 'を入力してください' }
  validates :external_id, presence: { message: 'を入力してください' }
end
